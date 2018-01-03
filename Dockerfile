FROM centos:7

ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]

RUN yum install -y make curl git sudo which
RUN sed -i -e 's/# %wheel\tALL=(ALL)\tNOPASSWD: ALL/%wheel\tALL=(ALL)\tNOPASSWD: ALL/' /etc/sudoers
RUN sed -i -e 's/%wheel\tALL=(ALL)\tALL/# %wheel\tALL=(ALL)\tALL/' /etc/sudoers
RUN visudo -c
RUN useradd -m worker -g wheel

WORKDIR /home/worker
USER worker
