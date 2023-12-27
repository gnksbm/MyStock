BASE_URL = https://raw.githubusercontent.com/Pepsi-Club/YamYamPick-ignored/main

define download_file
	@echo "Downloading $(3) to $(1) using token: $(2)"
	mkdir -p $(1)
	curl -H "Authorization: token $(2)" -o $(1)/$(3) $(BASE_URL)/$(3)
endef

.PHONY: download-privates

download-privates: download-xcconfigs download-env

download-xcconfigs:
	$(call download_file, XCConfig, $(token),Debug.xcconfig)
	$(call download_file, XCConfig, $(token),Release.xcconfig)

download-env:
	$(call download_file, fastlane, $(token),.env)
