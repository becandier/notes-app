# Makefile

API_ISSUER = 58613e41-3496-4c2a-8f60-2886cdde370f
KEY_ID = RSASU5T5YV

# ANSI code for blue text
BLUE = \033[0;34m
NC = \033[0m # No Color

gen:
	flutter pub run build_runner build --delete-conflicting-outputs

genw:
	flutter pub run build_runner watch --delete-conflicting-outputs

loc:
	flutter gen-l10n

testfl:
	@echo "$(BLUE)Проверьте включен ли у вас VPN и актуален ли код версии!$(NC)"
	flutter clean
	flutter pub get
	flutter build ipa
	xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey $(KEY_ID) --apiIssuer $(API_ISSUER)

release:
	@echo "$(BLUE)Проверьте включен ли у вас VPN и актуален ли код версии!$(NC)"
	flutter clean
	flutter pub get
	flutter build ipa
	xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey $(KEY_ID) --apiIssuer $(API_ISSUER)
	flutter build appbundle
debug:
	@echo "$(BLUE)Проверьте включен ли у вас VPN и актуален ли код версии!$(NC)"
	flutter clean
	flutter pub get
	flutter build ipa
	xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey $(KEY_ID) --apiIssuer $(API_ISSUER)
	flutter build apk
	

# xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey Q6WPLKL8NJ --apiIssuer 7d118c9f-e508-4d2a-8445-f774b6f6c38e