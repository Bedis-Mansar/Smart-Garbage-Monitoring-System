package smart.garbage.cot.boundaries;

import jakarta.json.Json;
import jakarta.json.JsonObject;
import java.io.StringReader;
import jakarta.websocket.DecodeException;
import jakarta.websocket.Decoder;
import smart.garbage.cot.entities.Sensor;

public class SensorJSONDecoder implements Decoder.Text<Sensor>{

    @Override
    public Sensor decode(String jsonMessage) throws DecodeException {

        JsonObject jsonObject = Json
                .createReader(new StringReader(jsonMessage)).readObject();
        String id=jsonObject.getString("id");
        Double value=jsonObject.isNull("value") ? null : jsonObject.getJsonNumber("value").doubleValue();
        Sensor sensor = new Sensor(id,value);
        return sensor;

    }

    @Override
    public boolean willDecode(String jsonMessage) {
        try {
            // Check if incoming message is valid JSON
            Json.createReader(new StringReader(jsonMessage)).readObject();
            return true;
        } catch (Exception e) {
            return false;
        }
    }

}
