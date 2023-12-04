{ pkgs, ... }: {
  home.username = "avm";
  home.homeDirectory = "/Users/avm";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
  home.packages = [

  ];
  programs.git = {
    enable = true;
    includes = [{path = "$HOME/.gitconfig";}];
  };
}