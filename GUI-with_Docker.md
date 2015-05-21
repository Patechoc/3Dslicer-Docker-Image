# Running Slider in command line mode, or better... within Docker

### Tip by Matt McCormick (Developer at Kitware)
instead of the OpenGL version, you may want to try the Xpra/Xdummy/Xvfb approach suggested by Steve first:
- [2015-02-21] http://slicer-devel.65872.n3.nabble.com/Slicer-batch-mode-td4033551.html
- [2015-04] https://www.xpra.org/trac/wiki/Xdummy

> [Xpra](http://en.wikipedia.org/wiki/Xpra):
> xpra or X Persistent Remote Applications is a tool which allows you to run X clients usually on a remote host and then direct their display to your local machine without losing any state.

> [Xdummy](https://www.xpra.org/trac/wiki/Xdummy)
>  Xdummy was originally developed by Karl Runge as a ​script to allow a standard X11 server to be used by non-root users with the dummy video driver (​xf86-video-dummy).

> [Xvfb (Virtual Frame Buffer)](http://blog.damore.it/2007/09/setting-up-virtual-frame-buffer-xvbf-to.html)
> Setting Up a Virtual Frame Buffe
> is an X server that can run on machines with no display hardware and no physical input devices. It emulates a dumb framebuffer using virtual memory.
> The primary use of this server was intended to be server testing. The mfb or cfb code for any depth can be exercised with this server without the need for real hardware that supports the desired depths. The X community has found many other novel uses for Xvfb, including testing clients against unusual depths and screen configurations, doing batch processing with Xvfb as a background rendering engine, load testing, as an aid to porting the X server to a new platform, and providing an unobtrusive way to run applications that don't really need an X server but insist on having one anyway. 
> Since then, the X11 server gained the ability to run without those LD_SO_PRELOAD hacks. This is now available for most distributions. 
> It differs from standard X forwarding in that it allows disconnection and reconnection without disrupting the forwarded application. It differs from VNC and similar remote display technologies in that xpra is rootless: i.e., applications forwarded by xpra appear on your desktop as normal windows managed by your window manager, rather than being all "trapped in a box together". Xpra also uses a custom protocol that is self-tuning and relatively latency-insensitive, and thus is usable over worse links than standard X.

## GUI application headless?

- [VPS Linux server](https://wiki.archlinux.org/index.php/Virtual_Private_Server)
- [Virtual Private Server](http://en.wikipedia.org/wiki/Virtual_private_server)
> Virtual private server (VPS) is a term **used by Internet hosting services to refer to a virtual machine**. The term is used for emphasizing that the virtual machine, although running in software on the same physical computer as other customers' virtual machines, is in many respects functionally equivalent to a separate physical computer, is dedicated to the individual customer's needs, has the privacy of a separate physical computer, and can be configured to run server software.
- [2014-10-13] [How to run GUI Applications with best performance in your headless Linux Servers](https://www.linkedin.com/pulse/20141013093159-4188152-how-to-run-gui-applications-with-best-performance-in-your-headless-linux-servers)
- [2014-10-18 Forum][GUI apps in a Docker container](http://stackoverflow.com/questions/16296753/can-you-run-gui-apps-in-a-docker-container)
> If you want to run a GUI application headless, then read [here > 2014-10-17](https://linuxmeerkat.wordpress.com/2014/10/17/running-a-gui-application-in-a-docker-container/).
> What you have to do is to **create a virtual monitor with xvfb or other similar software**. This is very helpful if you want to run Selenium tests for example with browsers.

- [2015-02-21] [](http://slicer-devel.65872.n3.nabble.com/Slicer-batch-mode-td4033551.html)
> Basically you can do something like this:
> sudo apt-get install -y xpra xserver-xorg-video-dummy
> ```shell
> xpra --xvfb=\"Xorg +extension GLX -config my.xorg.conf -logfile ${HOME}/.xpra/xorg.log\"  start :9
> env DISPLAY=:9 ./Slicer --python-script <script>
> ```

- [2015-03-20] [Example of Docker image running a GUI](http://fiji.sc/Docker) > works perfectly
```shell
$ docker run -it --rm fiji/fiji
```