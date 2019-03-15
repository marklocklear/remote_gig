
require "tty-spinner"
spinner = TTY::Spinner.new("[:spinner] Loading ...", format: :pulse_2)

spinner.auto_spin # Automatic animation with default interval

sleep(2) # Perform task

spinner.stop('Done!') # Stop animation