{ pkgs, ... }: {
  environment.systemPackages = with pkgs.unstable; [
    chromium
  ];

  programs = {
    chromium = {
      enable = true;
      extensions = [
      ];
      extraOpts = {
        "AutofillAddressEnabled" = false;
        "AutofillCreditCardEnabled" = false;
        "BuiltInDnsClientEnabled" = false;
        "DeviceMetricsReportingEnabled" = true;
        "ReportDeviceCrashReportInfo" = false;
        "PasswordManagerEnabled" = false;
        "SpellcheckEnabled" = true;
        "SpellcheckLanguage" = [
          "en-GB"
          "en-US"
        ];
        "VoiceInteractionHotwordEnabled" = false;
      };
    };
  };
}
