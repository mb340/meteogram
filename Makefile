VERSION = $(shell grep -i PluginInfo-Version package/metadata.desktop | cut -d'=' -f 2 )

all:
	@echo meteogram version = $(VERSION);
	cd package; \
	zip  -q -r "../com.github.mb340.meteogram-$(VERSION).plasmoid" \
		contents* \
		metadata.* \
		weather-widget.svg \
		--exclude "contents/tests/*"

clean:
	rm "com.github.mb340.meteogram-$(VERSION).plasmoid"
