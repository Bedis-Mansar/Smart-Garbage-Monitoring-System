package smart.garbage.cot.boundaries;
import jakarta.ejb.EJB;
import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import java.io.IOException;
import java.util.*;
import smart.garbage.cot.entities.Sensor;
import smart.garbage.cot.controllers.MqttMessageEventManager;

@ServerEndpoint(value = "/pushes", encoders = {SensorJSONEncoder.class}, decoders = {SensorJSONDecoder.class})
public class PublishWebsocketEndpoint {
    @EJB
    private MqttMessageEventManager mqttlistener;
    private static Hashtable<String, Session> sessions = new Hashtable<>(); // initialize sessions as empty Hashtable
    public static void broadcastMessage(Sensor sensor) {
        for (Session session : sessions.values()) {
            try {
                session.getBasicRemote().sendObject(sensor); // broadcast the message to websocket
                System.out.println("work: "); // for debugging
            } catch (IOException | EncodeException e) {
                e.printStackTrace();
            }
        }
    }
    @OnOpen
    public void onOpen(Session session){
        mqttlistener.Hello(); // print Hello on session start, for debugging
        sessions.put(session.getId(), session); //add the new session

    }

}
