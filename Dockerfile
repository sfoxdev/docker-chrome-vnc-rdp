FROM ubuntu:16.04
MAINTAINER SFoxDev <admin@sfoxdev.com>

ENV VNC_PASSWORD="" \
		DEBIAN_FRONTEND="noninteractive" \
    LC_ALL="C.UTF-8" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8"

ADD https://dl.google.com/linux/linux_signing_key.pub /tmp/
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list ; \
		echo "deb http://dl.google.com/linux/chrome-remote-desktop/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list ; \
		apt-key add /tmp/linux_signing_key.pub ; \
		apt-get update ; \
		apt-get install -y \
			google-chrome-stable \
			chrome-remote-desktop \
			fonts-takao \
			pulseaudio \
			supervisor \
			x11vnc \
			fluxbox \
			mc \
			xfce4 \
			xrdp ; \
		apt-get clean ; \
		rm -rf /var/cache/* /var/log/apt/* /var/lib/apt/lists/* /tmp/*

RUN addgroup chrome-remote-desktop ; \
		useradd -m -G chrome-remote-desktop,pulse-access -p chrome chrome ; \
		{ echo "chrome"; echo "chrome"; } | passwd chrome ; \
		ln -s /crdonly /usr/local/sbin/crdonly ; \
		ln -s /update /usr/local/sbin/update ; \
		mkdir -p /home/chrome/.config/chrome-remote-desktop ; \
		mkdir -p /home/chrome/.fluxbox ; \
		echo ' \n\
		session.screen0.toolbar.visible:        false\n\
		session.screen0.fullMaximization:       true\n\
		session.screen0.maxDisableResize:       true\n\
		session.screen0.maxDisableMove: true\n\
		session.screen0.defaultDeco:    NONE\n\
		' >> /home/chrome/.fluxbox/init ; \
		chown -R chrome:chrome /home/chrome/.config /home/chrome/.fluxbox

ADD conf/ /

VOLUME ["/home/chrome"]

EXPOSE 5900 3389

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
