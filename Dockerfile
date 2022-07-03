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
COPY ./src/ubuntu/install/remmina/custom_startup.sh $STARTUPDIR/custom_startup.sh
RUN chmod +x $STARTUPDIR/custom_startup.sh
RUN chmod 755 $STARTUPDIR/custom_startup.sh

### Install OBS Studio
COPY ./src/ubuntu/install/obs $INST_SCRIPTS/obs/
RUN bash $INST_SCRIPTS/obs/install_obs.sh  && rm -rf $INST_SCRIPTS/obs/

### OBS Studio pre-config
RUN mkdir -p $HOME/.config/obs-studio
COPY ./src/ubuntu/config/obs-studio/ $HOME/.config/obs-studio/

### Remmina pre-config
RUN mkdir -p $HOME/.config/remmina
RUN mkdir -p $HOME/.local/share/remmina

COPY ./src/ubuntu/config/remmina/ $HOME/.config/remmina/
COPY ./src/ubuntu/local-share/remmina/ $HOME/.local/share/remmina/
RUN chown -R 1000:0 $HOME

# Update the desktop environment to be optimized for a single application
RUN cp $HOME/.config/xfce4/xfconf/single-application-xfce-perchannel-xml/* $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/
RUN cp /usr/share/extra/backgrounds/bg_kasm.png /usr/share/extra/backgrounds/bg_default.png
RUN apt-get remove -y xfce4-panel

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000