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
                    "VAD Threshold (%)" = 40.0;
                    "VAD Grace Period (ms)" = 200;
                  };
                }
              ];
            };
            "capture.props" = {
              "node.name" = "capture.rnnoise_source";
              "audio.rate" = 48000;
			  "target.object" = "alsa_input.usb-Jieli_Technology_USB_Composite_Device_55161A7892785A13-00.mono-fallback";
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
