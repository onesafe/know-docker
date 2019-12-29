#define _GNU_SOURCE
#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#include <sched.h>
#include <signal.h>
#include <unistd.h>

#include <sys/mount.h>
#include <stdlib.h>
#define STACK_SIZE (1024 * 1024)

static char container_stack[STACK_SIZE];

char* const container_args[] = {
    "/bin/bash",
    NULL
};

void set_uid_map(pid_t pid, int inside_id, int outside_id, int length){
    char path[256];
    sprintf(path, "/proc/%d/uid_map", getpid());
    FILE* uid_map = fopen(path, "w");
    fprintf(uid_map, "%d %d %d", inside_id, outside_id, length);
    fclose(uid_map);
}

void set_gid_map(pid_t pid, int inside_id, int outside_id, int length){
    char path[256];
    sprintf(path, "/proc/%d/gid_map", getpid());
    FILE* gid_map = fopen(path, "w");
    //printf("*****gid---Pid: %d *****\n", getpid());
    fprintf(gid_map, "%d %d %d", inside_id, outside_id, length);
    fclose(gid_map);
}

// 容器进程运行的程序主函数
int container_main(void *args)
{
    printf("在容器进程中！\n");

    // 挂载/proc，从而ps -ef只能看到自己的进程
	if (mount("proc", "/proc", "proc", 0, "") != 0) {
        printf("failed to mount /proc \n");
		exit(-1);
	}

    printf("挂载/proc成功! \n");

    printf("eUID = %d; eGID = %d; \n", geteuid(), getegid());

    pid_t pid = getpid();
    printf("pid = %d \n", pid);
    set_uid_map(pid, 0, 1000, 1);
    set_gid_map(pid, 0, 1000, 1);

	// 设置容器的主机名
	sethostname("container_one", 14);
    execv(container_args[0], container_args); // 执行/bin/bash   return 1;
}

int main(int args, char *argv[])
{
    printf("程序开始\n");

    // clone 容器进程
    int container_pid = clone(container_main, container_stack + STACK_SIZE, SIGCHLD | CLONE_NEWUTS | CLONE_NEWIPC | CLONE_NEWPID | CLONE_NEWNS | CLONE_NEWNET | CLONE_NEWUSER, NULL);

    // 等待容器进程结束
    waitpid(container_pid, NULL, 0);
    return 0;
}

