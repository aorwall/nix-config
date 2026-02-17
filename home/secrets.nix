{ ... }:
{
  sops = {
    age.keyFile = "/Users/albert/.config/sops/age/keys.txt";
    defaultSopsFile = ../secrets/secrets.yaml;
    # Declare secrets here as needed, e.g.:
    # secrets."example_token" = {};
  };
}
