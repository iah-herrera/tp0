# Imagen base de ubuntu 22.04
FROM ubuntu:22.04

# Actualizar SO e instalar SSH
RUN apt update && \
    apt install -y openssh-server

# Instalacion del compilador de gcc y libreadline-dev
RUN apt -y install build-essential gdb libreadline-dev

# Instalamos un editor de texto
#RUN apt -y install nano

# Instalamos GIT
RUN apt -y install git

#usuario para el SSH
RUN useradd -m -s /bin/bash utnso && echo 'utnso:utnso' | chpasswd

# Eliminamos los archivos temporales y cache de APT
RUN rm -rf /var/lib/apt/lists/*

# Configuramos SSH
RUN mkdir /var/run/sshd
#RUN ssh-keygen -A

# Cambiamos el directorio donde trabajamos
WORKDIR /opt

# Instalacion de las dependencias de la catedra
RUN git clone https://github.com/sisoputnfrba/so-commons-library && \
    cd so-commons-library && \
    make debug && \
    make install

# Volvemos a cambiar el directorio donde trabajamos de forma final
WORKDIR /home/utnso

# Exponer el puerto SSH
EXPOSE 22 4444

# Iniciar el servidor SSH al ejecutar el contenedor
CMD ["/bin/bash", "-c", "/usr/sbin/sshd -D"]

#SACALE EL EXPOSE Y CREAR DOCKER COMPOSE