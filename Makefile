SHELL := /bin/bash

# ──────────────────────────────────────────────────────────────
# This is exactly what your `flutterme` alias does — baked in directly
# so builds don't depend on aliases, login shells, or which shell
# `make` happens to invoke. Edit FLUTTER_BIN if Flutter ever moves.
# ──────────────────────────────────────────────────────────────
FLUTTER_BIN := /Users/mac/flutter/bin
export PATH := $(FLUTTER_BIN):$(PATH)

.PHONY: all release flutterme apk aab clean get analyze test format doctor \
        icons gen watch pod-install install-apk uninstall build-ios build-ios-ipa \
        upgrade outdated clean-derived clean-ios help

all: release

# Sanity check that Flutter resolves correctly
flutterme:
	@flutter --version

# ──────────────────────────────────────────────────────────────
# Main release flow: flutterme -> ask version -> build apk + aab
# ──────────────────────────────────────────────────────────────
release:
	@read -p "Use version from pubspec.yaml? (y/n): " use_pubspec; \
	if [ "$$use_pubspec" = "y" ] || [ "$$use_pubspec" = "Y" ]; then \
		VERSION_LINE=$$(grep '^version:' pubspec.yaml | sed 's/version:[[:space:]]*//'); \
		VERSION_NAME=$$(echo $$VERSION_LINE | cut -d'+' -f1); \
		VERSION_CODE=$$(echo $$VERSION_LINE | cut -d'+' -f2); \
		if [ -z "$$VERSION_NAME" ] || [ -z "$$VERSION_CODE" ]; then \
			echo "❌ Could not parse version from pubspec.yaml (expected format: version: 1.0.1+12)"; \
			exit 1; \
		fi; \
		echo "📦 Using pubspec.yaml version: $$VERSION_NAME+$$VERSION_CODE"; \
	else \
		read -p "Enter version name (e.g. 1.0.1): " VERSION_NAME; \
		while ! [[ $$VERSION_NAME =~ ^[0-9]+\.[0-9]+\.[0-9]+$$ ]]; do \
			echo "❌ Invalid format. Use x.y.z, e.g. 1.0.1"; \
			read -p "Enter version name (e.g. 1.0.1): " VERSION_NAME; \
		done; \
		read -p "Enter version code (integer, e.g. 12): " VERSION_CODE; \
		while ! [[ $$VERSION_CODE =~ ^[0-9]+$$ ]]; do \
			echo "❌ Invalid version code, must be a plain integer."; \
			read -p "Enter version code (integer, e.g. 12): " VERSION_CODE; \
		done; \
	fi; \
	echo ""; \
	echo "🏗  Building APK  (version $$VERSION_NAME+$$VERSION_CODE)..."; \
	flutter build apk --release --build-name=$$VERSION_NAME --build-number=$$VERSION_CODE; \
	echo ""; \
	echo "🏗  Building App Bundle (version $$VERSION_NAME+$$VERSION_CODE)..."; \
	flutter build appbundle --release --build-name=$$VERSION_NAME --build-number=$$VERSION_CODE; \
	echo ""; \
	echo "✅ Done!"; \
	echo "   APK: build/app/outputs/flutter-apk/app-release.apk"; \
	echo "   AAB: build/app/outputs/bundle/release/app-release.aab"

# ──────────────────────────────────────────────────────────────
# Standalone build targets (no version prompt — uses pubspec.yaml)
# ──────────────────────────────────────────────────────────────
apk:
	flutter build apk --release

aab:
	flutter build appbundle --release

build-ios:
	flutter build ios --release

build-ios-ipa:
	flutter build ipa --release

# ──────────────────────────────────────────────────────────────
# Everyday project commands
# ──────────────────────────────────────────────────────────────
get:
	flutter pub get

clean:
	flutter clean && flutter pub get

analyze:
	flutter analyze

test:
	flutter test

format:
	dart format lib/

doctor:
	flutter doctor -v

upgrade:
	flutter pub upgrade

outdated:
	flutter pub outdated

# build_runner helpers (freezed / json_serializable / riverpod_generator etc.)
gen:
	flutter pub run build_runner build --delete-conflicting-outputs

watch:
	flutter pub run build_runner watch --delete-conflicting-outputs

# app icons (requires flutter_launcher_icons configured in pubspec.yaml)
icons:
	flutter pub run flutter_launcher_icons

# iOS pod install
pod-install:
	cd ios && pod install

# install last built release APK on a connected/booted device
install-apk:
	adb install -r build/app/outputs/flutter-apk/app-release.apk

uninstall:
	@read -p "Enter package name to uninstall (e.g. com.example.app): " PKG; \
	adb uninstall $$PKG

# clear Xcode's DerivedData — safe, just forces a full rebuild + re-index
clean-derived:
	rm -rf $(HOME)/Library/Developer/Xcode/DerivedData/*
	@echo "✅ Cleared Xcode DerivedData"

clean-ios: clean-derived
	cd ios && rm -rf Pods Podfile.lock && pod install
	@echo "✅ Reset iOS Pods"

help:
	@echo "Available targets:"
	@echo "  make release       - flutterme, then prompt for version, build apk + aab"
	@echo "  make apk           - build release apk (pubspec.yaml version)"
	@echo "  make aab           - build release app bundle (pubspec.yaml version)"
	@echo "  make build-ios     - build release iOS app"
	@echo "  make build-ios-ipa - build release .ipa"
	@echo "  make get           - flutter pub get"
	@echo "  make clean         - flutter clean + pub get"
	@echo "  make analyze       - flutter analyze"
	@echo "  make test          - flutter test"
	@echo "  make format        - dart format lib/"
	@echo "  make doctor        - flutter doctor -v"
	@echo "  make upgrade       - flutter pub upgrade"
	@echo "  make outdated      - flutter pub outdated"
	@echo "  make gen           - build_runner build (codegen)"
	@echo "  make watch         - build_runner watch (codegen, live)"
	@echo "  make icons         - regenerate app launcher icons"
	@echo "  make pod-install   - cd ios && pod install"
	@echo "  make install-apk   - adb install release apk on device"
	@echo "  make uninstall     - adb uninstall by package name"
	@echo "  make clean-derived - clear Xcode DerivedData"
	@echo "  make clean-ios     - clear DerivedData + reset Pods"