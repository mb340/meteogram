
### Install from local source

	plasmapkg2 -i package/

### Update from local source

	plasmapkg2 -u package/

### Create plasmoid package

	tar -czvf com.github.mb340.meteogram.tar.gz package/

### Run with different language

	LANG="de_DE.UTF-8" LANGUAGE="de_DE:de" LC_TIME="de_DE.UTF-8" plasmawindowed com.github.mb340.meteogram

### High DPI / Scale factor

	QT_SCALE_FACTOR=2.0 plasmawindowed com.github.mb340.meteogram
