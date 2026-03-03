{ pkgs, ... }: {
  i18n.inputMethod = {
    enable = true;
    type   = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
    };
  };

  fonts.packages = with pkgs; [
    ipafont
    kochi-substitute
    noto-fonts-cjk-sans
  ];

  # this was what was causing the problems ... once I commented it out, `Mozc` became available in the
  # config tool, and my CAPS_LOCK+J binding started working
  #
  # environment.systemPackages = with pkgs; [
  #   fcitx5
  #   fcitx5-mozc
  #   fcitx5-configtool
  # ];
}
