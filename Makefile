generate:
	tuist fetch
	tuist generate

clean:
	rm -rf **/**/**/*.xcodeproj
	rm -rf **/**/*.xcodeproj
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace
	rm -rf **/**/**/Derived/
	rm -rf **/**/Derived/
	rm -rf **/Derived/
	rm -rf Derived/

reset:
	tuist clean
	rm -rf **/**/**/*.xcodeproj
	rm -rf **/**/*.xcodeproj
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace

regenerate:
	rm -rf **/**/**/*.xcodeproj
	rm -rf **/**/*.xcodeproj
	rm -rf **/*.xcodeproj
	rm -rf *.xcworkspace
	tuist clean
	tuist fetch
	tuist generate

cleancache:
	rm -rf ~/Library/Developer/Xcode/DerivedData/*

BASE_URL = https://raw.githubusercontent.com/gnksbm/KISStock-ignored/main

define download_file
	@echo "Downloading $(3) to $(1) using token: $(2)"
	mkdir -p $(1)
	curl -H "Authorization: token $(2)" -o $(1)/$(3) $(BASE_URL)/$(3)
endef

.PHONY: download-privates

download-privates: download-xcconfigs

download-xcconfigs:
	$(call download_file, XCConfig, $(token),Debug_Secrets.xcconfig)
	$(call download_file, XCConfig, $(token),Debug.xcconfig)
	$(call download_file, XCConfig, $(token),Release.xcconfig)
	$(call download_file, XCConfig, $(token),Widget_Debug.xcconfig)
	$(call download_file, XCConfig, $(token),Widget_Release.xcconfig)
