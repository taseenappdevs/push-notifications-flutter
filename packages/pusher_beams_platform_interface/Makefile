all: generate_interface

generate_interface:
	flutter pub run pigeon \
          --input pigeons/messages.dart \
          --dart_out lib/method_channel_pusher_beams.dart \
          --objc_header_out ../pusher_beams/ios/Classes/messages.h \
          --objc_source_out ../pusher_beams/ios/Classes/messages.m \
          --java_out ../pusher_beams/android/src/main/java/com/pusher/pusher_beams/Message.java \
          --java_package "com.pusher.pusher_beams"
