// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import SidebarController from "./sidebar_controller"

eagerLoadControllersFrom("controllers", application)
application.register("sidebar", SidebarController)
