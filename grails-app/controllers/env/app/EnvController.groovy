package env.app

class EnvController {
    def index() { 
		render System.getProperties().toString();
	}
}
