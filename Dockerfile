ARG BASE_TAG="1.10.0-rolling"
#ARG BASE_IMAGE="core-ubuntu-jammy"
ARG BASE_IMAGE="core-ubuntu-bionic"
FROM kasmweb/$BASE_IMAGE:$BASE_TAG

USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
WORKDIR $HOME

### Envrionment config
ENV DEBIAN_FRONTEND noninteractive
ENV KASM_RX_HOME $STARTUPDIR/kasmrx
ENV INST_SCRIPTS $STARTUPDIR/install


######### Customize Container Here ###########

### Install Remmina
COPY ./src/ubuntu/install/remmina $INST_SCRIPTS/remmina/
RUN bash $INST_SCRIPTS/remmina/install_remmina.sh  && rm -rf $INST_SCRIPTS/remmina/

### Install OBS Studio
COPY ./src/ubuntu/install/obs $INST_SCRIPTS/obs/
RUN bash $INST_SCRIPTS/obs/install_obs.sh  && rm -rf $INST_SCRIPTS/obs/

### OBS Studio pre-config
RUN mkdir -p $HOME/.config/obs-studio
COPY ./src/ubuntu/config/obs-studio $HOME/.config/obs-studio

### Remmina pre-config
RUN mkdir -p $HOME/.config/remmina
RUN mkdir -p $HOME/.local/share/remmina
COPY ./src/ubuntu/config/remmina $HOME/.config/remmina
COPY ./src/ubuntu/local-share/remmina $HOME/.local/share/remmina

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000