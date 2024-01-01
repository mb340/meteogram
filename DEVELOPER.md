
### Install from local source

	kpackagetool6 -i package/ -t Plasma/Applet

### Update from local source

	kpackagetool6 -u package/ -t Plasma/Applet

### Create plasmoid package

	tar -czvf com.github.mb340.meteogram.plasmoid package/

### Run with different language

	LANG="de_DE.UTF-8" LANGUAGE="de_DE:de" LC_TIME="de_DE.UTF-8" plasmawindowed com.github.mb340.meteogram

### High DPI / Scale factor

	QT_SCALE_FACTOR=2.0 plasmawindowed com.github.mb340.meteogram
