Pod::Spec.new do |spec|

  spec.name         = "BiometricKYS"
  spec.version      = "1.0.0"
  spec.summary      = "KYS IOS v2.0 By Tanir"
  spec.homepage     = "https://github.com/biometrickz/kyc-ios-v2.0"
  spec.license      = "KYS 2.0"
  spec.platform     = :ios, "12.0"
  spec.author             = { "Kaldybay Tanirbergen" => "inst: self.tanir" }
  spec.source       = { :git => "https://github.com/biometrickz/kyc-ios-v2.0.git", :tag => "1.0.0" }
  spec.source_files  = "BiometricKYS/**/*"
  spec.swift_version = "5.0"
end

