{
  services.opensnitch = {
    rules = {
      ssh = {
        "name" = "allow-ssh";
        "enabled" = true;
        "action" = "allow";
        "duration" = "always";
        "operator" = {
          "type" = "simple";
          "sensitive" = false;
          "operand" = "dest.port";
          "data" = "22";
        };
      };
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
      dhcp = {
        "name" = "allow-dhcp";
        "enabled" = true;
        "action" = "allow";
        "duration" = "always";
        "operator" = {
          "type" = "simple";
          "sensitive" = false;
          "operand" = "dest.port";
          "data" = "67";
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
      chrome-dns = {
        "name" = "allow-chrome-dns";
        "enabled" = true;
        "action" = "allow";
        "duration" = "always";
        "operator" = {
          "type" = "simple";
          "sensitive" = false;
          "operand" = "dest.port";
          "data" = "5353";
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
      spotify2 = {
        "name" = "allow-spotify2";
        "enabled" = true;
        "action" = "allow";
        "duration" = "always";
        "operator" = {
          "type" = "simple";
          "sensitive" = false;
          "operand" = "dest.port";
          "data" = "52877";
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
