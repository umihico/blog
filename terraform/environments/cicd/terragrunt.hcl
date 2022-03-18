include "root" {
  path = find_in_parent_folders()
}

inputs = {
  vars = {
    source_location = get_env("SOURCE_LOCATION")
  }
}
