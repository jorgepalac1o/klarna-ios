Pod::Spec.new do |s|
    s.name         = "KlarnaMobileSDK"
    s.version      = "3.0.1"
    s.summary      = "Klarna Mobile SDK for iOS"
    s.description  = <<-DESC
    Klarna Mobile SDK for iOS apps.
    DESC
    s.homepage     = "https://github.com/klarna/klarna-mobile-sdk.git"
    s.license      = { :type => "Apache License, Version 2.0", :text => "https://raw.githubusercontent.com/klarna/klarna-mobile-sdk/refs/heads/master/LICENSE" }
    s.author       = { "Klarna Mobile SDK Team" => "mobile.sdk@klarna.com" }
    s.platform     = :ios, "10.0"
    s.source       = { :http => "https://github.com/jorgepalac1o/klarna-ios/releases/download/3.0.1/Klarna.zip" }
    s.requires_arc = true
    s.swift_version = "5.0"

    s.subspec 'core' do |sb|
        sb.vendored_frameworks = 'KlarnaCore.xcframework'
    end

    s.subspec 'full' do |sb|
        sb.dependency 'KlarnaMobileSDK/core'
        sb.vendored_frameworks = 'KlarnaMobileSDK.xcframework'
    end

    s.subspec 'basic' do |sb|
        sb.vendored_frameworks = 'KlarnaMobileSDK.xcframework', 'KlarnaCore.xcframework'
    end

    s.default_subspec = 'basic'

end
