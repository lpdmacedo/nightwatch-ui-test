import ping.app.PingController
import grails.test.mixin.TestFor
import spock.lang.Specification

@TestFor(PingController)
class PingControllerTest extends Specification {

    void "test ping"() {
        when:
            controller.index()
        then:
            controller.response.text == 'pong'
    }   
}

