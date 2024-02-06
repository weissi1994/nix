{
  services.opensnitch = {
    rules = {
      dns = {
        "name" = "allow-dns";
        "enabled" = true;
        "action" = "allow";
        "duration" = "always";
        "operator" = {
          "type" = "simple";
          "sensitive" = false;
          "operand" = "dest.port";
          "data" = "53";
        };
      };
      chrome-notifications = {
        "name" = "allow-chrome-notifications";
        "enabled" = true;
        "action" = "allow";
        "duration" = "always";
        "operator" = {
          "type" = "simple";
          "sensitive" = false;
          "operand" = "dest.port";
          "data" = "5228";
        };
      };
      chrome-quic = {
        "name" = "allow-chrome-quic";
        "enabled" = true;
        "action" = "allow";
        "duration" = "always";
        "operator" = {
          "type" = "simple";
          "sensitive" = false;
          "operand" = "dest.port";
          "data" = "1900";
        };
      };
      spotify = {
        "name" = "allow-spotify";
        "enabled" = true;
        "action" = "allow";
        "duration" = "always";
        "operator" = {
          "type" = "simple";
          "sensitive" = false;
          "operand" = "dest.port";
          "data" = "57621";
        };
      };
      http = {
        "name" = "allow-http";
        "enabled" = true;
        "action" = "allow";
        "duration" = "always";
        "operator" = {
          "type" = "simple";
          "sensitive" = false;
          "operand" = "dest.port";
          "data" = "80";
        };
      };
      https = {
        "name" = "allow-https";
        "enabled" = true;
        "action" = "allow";
        "duration" = "always";
        "operator" = {
          "type" = "simple";
          "sensitive" = false;
          "operand" = "dest.port";
          "data" = "443";
        };
      };
    };
  };
}
