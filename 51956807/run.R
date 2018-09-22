require(shiny)
require(rprojroot)
folder_address = dirname(thisfile())
runApp(folder_address, launch.browser=TRUE)