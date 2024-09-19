# Justfile for Lustre's dev tools

run: start_dev_server

# Add Lustre dev tools as a dev dependency
add_lustre_dev_tools:
    gleam add lustre_dev_tools --dev

# Fix gleam_json version issue
fix_gleam_json_version:
    echo 'gleam_json = "1.0.1"' >> gleam.toml

# Run Lustre's dev build command
build_app:
    gleam run -m lustre/dev build app

# Build a Lustre component as a Web Component
build_component:
    gleam run -m lustre/dev build component

# Start the Lustre development server
start_dev_server:
    gleam run -m lustre/dev start

# Download esbuild binary manually (if needed)
add_esbuild:
    gleam run -m lustre/dev add esbuild

# Download Tailwind binary manually (if needed)
add_tailwind:
    gleam run -m lustre/dev add tailwind

# Print Lustre dev tool help
lustre_help:
    gleam run -m lustre/dev -- --help
