{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.rnnoise-plugin ];

  services.pipewire = {
    enable = true;
    
    extraConfig.pipewire."99-input-denoising" = {
      "context.modules" = [
        {
          name = "libpipewire-module-filter-chain";
          args = {
            "node.description" = "Noise Cancelling Source";
            "media.name" = "Noise Cancelling Source";
            "filter.graph" = {
              nodes = [
                {
                  type = "ladspa";
                  name = "rnnoise";
                  plugin = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                  label = "noise_suppressor_mono";
                  control = {
                    "VAD Threshold (%)" = 50.0;
                    "VAD Grace Period (ms)" = 200;
                  };
                }
              ];
            };
            "capture.props" = {
              "node.name" = "capture.rnnoise_source";
              "node.passive" = true;
              "audio.rate" = 48000;
              # This ensures it doesn't accidentally grab a monitor stream
              "target.object" = "alsa_input"; 
            };
            "playback.props" = {
              "node.name" = "rnnoise_source";
              "media.class" = "Audio/Source";
              "audio.rate" = 48000;
            };
          };
        }
      ];
    };
	# disable dogshit iem mic
    wireplumber.extraConfig."51-disable-iem-mic" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            {
              "node.name" = "~alsa_input.usb-Apple.*";
            }
          ];
          actions = {
            "update-props" = {
              "node.disabled" = true;
            };
          };
        }
      ];
    };
  };
}
