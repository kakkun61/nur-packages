{ pkgs, fetchzip }:

let
  version = "80e0814140c33201adf0e5213c426fb7bd5f47cf";
  project =
    fetchzip {
      url = "https://github.com/kakkun61/wd/tarball/${version}";
      sha256 = "sha256-usZTBF9pk0IsGdZb6IqEHBEaBX7mnXutykpm9TJHAWk=";
      extension = "tar.gz";
    };
in
(import "${project}/linux" { inherit pkgs; }).default.overrideAttrs {
  broken = true;
}
