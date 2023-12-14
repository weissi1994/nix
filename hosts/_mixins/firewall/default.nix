{ config, desktop, roles, hostname, lib, pkgs, username, ... }:
let
  format = pkgs.formats.json {};

  system-fw = {
    Enabled = true;
    Version = 1;
    SystemRules = [
      {
        Rule = {
          Table = "mangle";
          Chain = "OUTPUT";
          UUID = "";
          Enabled = false;
          Position = "0";
          Description = "Allow icmp";
          Parameters = "-p icmp";
          Expressions = [];
          Target = "ACCEPT";
          TargetParameters = "";
        };
        Chains = [];
      }
      {
        Rule = null;
        Chains = [
          {
            Name = "forward";
            Table = "filter";
            Family = "inet";
            Priority = "";
            Type = "filter";
            Hook = "forward";
            Policy = "accept";
            Rules = [];
          }
          {
            Name = "output";
            Table = "filter";
            Family = "inet";
            Priority = "";
            Type = "filter";
            Hook = "output";
            Policy = "accept";
            Rules = [];
          }
          {
            Name = "input";
            Table = "filter";
            Family = "inet";
            Priority = "";
            Type = "filter";
            Hook = "input";
            Policy = "drop";
            Rules = [
              {
                Table = "";
                Chain = "";
                UUID = "";
                Enabled = true;
                Position = "0";
                Description = "Allow SSH server connections when input policy is DROP";
                Parameters = "";
                Expressions = [
                  {
                    Statement = {
                      Op = "";
                      Name = "tcp";
                      Values = [
                        {
                          Key = "dport";
                          Value = "22";
                        }
                      ];
                    };
                  }
                ];
                Target = "accept";
                TargetParameters = "";
              }
              {
                Table = "";
                Chain = "";
                UUID = "";
                Enabled = true;
                Position = "0";
                Description = "[profile-drop-inbound] allow localhost connections";
                Parameters = "";
                Expressions = [
                  {
                    Statement = {
                      Op = "";
                      Name = "iifname";
                      Values = [
                        {
                          Key = "lo";
                          Value = "";
                        }
                      ];
                    };
                  }
                ];
                Target = "accept";
                TargetParameters = "";
              }
              {
                Table = "";
                Chain = "";
                UUID = "";
                Enabled = true;
                Position = "0";
                Description = "[profile-drop-inbound] allow established,related connections";
                Parameters = "";
                Expressions = [
                  {
                    Statement = {
                      Op = "";
                      Name = "ct";
                      Values = [
                        {
                          Key = "state";
                          Value = "related";
                        }
                        {
                          Key = "state";
                          Value = "established";
                        }
                      ];
                    };
                  }
                ];
                Target = "accept";
                TargetParameters = "";
              }
            ] ++ lib.optional (roles != []) {
              Table = "";
              Chain = "";
              UUID = "";
              Enabled = true;
              Position = "0";
              Description = "Allow HTTP server connections when input policy is DROP";
              Parameters = "";
              Expressions = [
                {
                  Statement = {
                    Op = "";
                    Name = "tcp";
                    Values = [
                      {
                        Key = "dport";
                        Value = "80";
                      }
                      {
                        Key = "dport";
                        Value = "443";
                      }
                      {
                        Key = "dport";
                        Value = "8080";
                      }
                    ];
                  };
                }
              ];
              Target = "accept";
              TargetParameters = "";
            } ++ lib.optional (builtins.elem ../server/roles/gitlab.nix roles) {
              Table = "";
              Chain = "";
              UUID = "";
              Enabled = true;
              Position = "0";
              Description = "Allow Gitlab SSH server connections when input policy is DROP";
              Parameters = "";
              Expressions = [
                {
                  Statement = {
                    Op = "";
                    Name = "tcp";
                    Values = [
                      {
                        Key = "dport";
                        Value = "2222";
                      }
                    ];
                  };
                }
              ];
              Target = "accept";
              TargetParameters = "";
            } ++ lib.optional (builtins.elem ../server/roles/netboot.nix roles) {
              Table = "";
              Chain = "";
              UUID = "";
              Enabled = true;
              Position = "0";
              Description = "Allow Netboot server connections when input policy is DROP";
              Parameters = "";
              Expressions = [
                {
                  Statement = {
                    Op = "";
                    Name = "udp";
                    Values = [
                      {
                        Key = "dport";
                        Value = "69";
                      }
                    ];
                  };
                }
              ];
              Target = "accept";
              TargetParameters = "";
            };
          }
          {
            Name = "filter-prerouting";
            Table = "nat";
            Family = "inet";
            Priority = "";
            Type = "filter";
            Hook = "prerouting";
            Policy = "accept";
            Rules = [];
          }
          {
            Name = "prerouting";
            Table = "mangle";
            Family = "inet";
            Priority = "";
            Type = "mangle";
            Hook = "prerouting";
            Policy = "accept";
            Rules = [];
          }
          {
            Name = "postrouting";
            Table = "mangle";
            Family = "inet";
            Priority = "";
            Type = "mangle";
            Hook = "postrouting";
            Policy = "accept";
            Rules = [];
          }
          {
            Name = "prerouting";
            Table = "nat";
            Family = "inet";
            Priority = "";
            Type = "natdest";
            Hook = "prerouting";
            Policy = "accept";
            Rules = [];
          }
          {
            Name = "postrouting";
            Table = "nat";
            Family = "inet";
            Priority = "";
            Type = "natsource";
            Hook = "postrouting";
            Policy = "accept";
            Rules = [];
          }
          {
            Name = "input";
            Table = "nat";
            Family = "inet";
            Priority = "";
            Type = "natsource";
            Hook = "input";
            Policy = "accept";
            Rules = [];
          }
          {
            Name = "output";
            Table = "nat";
            Family = "inet";
            Priority = "";
            Type = "natdest";
            Hook = "output";
            Policy = "accept";
            Rules = [];
          }
          {
            Name = "output";
            Table = "mangle";
            Family = "inet";
            Priority = "";
            Type = "mangle";
            Hook = "output";
            Policy = "accept";
            Rules = [
              {
                Table = "";
                Chain = "";
                UUID = "";
                Enabled = true;
                Position = "0";
                Description = "Allow ICMP";
                Parameters = "";
                Expressions = [
                  {
                    Statement = {
                      Op = "";
                      Name = "icmp";
                      Values = [
                        {
                          Key = "type";
                          Value = "echo-request,echo-reply,destination-unreachable";
                        }
                      ];
                    };
                  }
                ];
                Target = "accept";
                TargetParameters = "";
              }
              {
                Table = "";
                Chain = "";
                UUID = "";
                Enabled = true;
                Position = "0";
                Description = "Allow ICMPv6";
                Parameters = "";
                Expressions = [
                  {
                    Statement = {
                      Op = "";
                      Name = "icmpv6";
                      Values = [
                        {
                          Key = "type";
                          Value = "echo-request,echo-reply,destination-unreachable";
                        }
                      ];
                    };
                  }
                ];
                Target = "accept";
                TargetParameters = "";
              }
              {
                Table = "";
                Chain = "";
                UUID = "";
                Enabled = false;
                Position = "0";
                Description = "Exclude WireGuard VPN from being intercepted";
                Parameters = "";
                Expressions = [
                  {
                    Statement = {
                      Op = "";
                      Name = "udp";
                      Values = [
                        {
                          Key = "dport";
                          Value = "51820";
                        }
                      ];
                    };
                  }
                ];
                Target = "accept";
                TargetParameters = "";
              }
            ];
          }
          {
            Name = "forward";
            Table = "mangle";
            Family = "inet";
            Priority = "";
            Type = "mangle";
            Hook = "forward";
            Policy = "accept";
            Rules = [
              {
                Table = "";
                Chain = "";
                UUID = "";
                Enabled = false;
                Position = "0";
                Description = "Intercept forwarded connections (docker, etc)";
                Parameters = "";
                Expressions = [
                  {
                    Statement = {
                      Op = "";
                      Name = "ct";
                      Values = [
                        {
                          Key = "state";
                          Value = "new";
                        }
                      ];
                    };
                  }
                ];
                Target = "queue";
                TargetParameters = "num 0";
              }
            ];
          }
        ];
      }
    ];
  };
in
{
  imports = []
  ++ lib.optional (builtins.pathExists (./. + "/${username}.nix")) ./${username}.nix
  ++ lib.optional (builtins.pathExists (./. + "/${hostname}.nix")) ./${hostname}.nix
  ++ lib.optional (roles != []) ./server.nix
  ++ lib.optional (desktop != null) ./desktop.nix;

  environment.etc."opensnitchd/system-fw.json".source = format.generate "system-fw.json" system-fw;

  services.opensnitch = {
    enable = true;
    settings = {
      DefaultAction = "deny";
      DefaultDuration = "until restart";
    };
    rules = {
      systemd-timesyncd = {
        name = "systemd-timesyncd";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-timesyncd";
        };
      };
      systemd-resolved = {
        name = "systemd-resolved";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.systemd}/lib/systemd/systemd-resolved";
        };
      };
      nsncd = {
        name = "nsncd";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.unstable.nsncd}/bin/nsncd";
        };
      };
      openssh = {
        name = "openssh";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.openssh}/bin/ssh";
        };
      };
      nix = {
        name = "nix";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.nix}/bin/nix";
        };
      };
      curl = {
        name = "curl";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.curl}/bin/curl";
        };
      };
      git-remote-http = {
        name = "git-remote-http";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.git}/libexec/git-core/git-remote-http";
        };
      };
      fwupd = {
        name = "fwupd";
        enabled = true;
        action = "allow";
        duration = "always";
        operator = {
          type = "simple";
          sensitive = false;
          operand = "process.path";
          data = "${lib.getBin pkgs.fwupd}/bin/.fwupdmgr-wrapped";
        };
      };
    };
  };
}
