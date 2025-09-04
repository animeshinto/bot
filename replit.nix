{ pkgs }: {
  deps = [
    pkgs.python311
    pkgs.chromium
    pkgs.chromedriver
    pkgs.python311Packages.selenium
    pkgs.openssl
    pkgs.postgresql
  ];
}