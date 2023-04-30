FROM gcc:12.2.0

ENV TZ=Asia/Kolkata \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
&& apt-get -y install vim gdb gdbserver curl sudo wget openssh-server dos2unix file zip flex

# configure SSH for communication with Visual Studio 
RUN mkdir -p /var/run/sshd

RUN echo 'root:root' | chpasswd \
    && sed -i -E 's/#\s*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
	sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
    echo 'PermitEmptyPasswords yes' >> /etc/ssh/sshd_config && \
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config && \
    ssh-keygen -A

# For gdbserver
EXPOSE 2000

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]


# Build through CLI:
# docker run --rm -v /Users/dhrsharm/Documents/cpp_open_source/native_docker_debugging:/native_docker_debugging -w /native_docker_debugging gcc-12.2-hello-world g++ -std=c++14 -g ./src/main.cpp -o ./bin/hello_world

# Logging in:
# docker run -d -v /Users/dhrsharm/Documents/cpp_open_source/native_docker_debugging:/native_docker_debugging -p 2222:22 -p 2000:2000 --privileged --security-opt seccomp:unconfined --name gcc-12.2-run-hello-world gcc-12.2-hello-world