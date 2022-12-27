package smart.garbage.cot.entities;

import jakarta.nosql.mapping.Column;
import jakarta.nosql.mapping.Entity;
import jakarta.nosql.mapping.Id;
import jakarta.json.bind.annotation.JsonbVisibility;
import java.io.Serializable;
import java.util.Objects;

@Entity
@JsonbVisibility(FieldPropertyVisibilityStrategy.class)
public class Sensor implements Serializable  { // Sensor entity for MQTT messages
    @Id
    private String id;

    @Column
    private Double value;

    public Sensor() {
    }

    public Sensor(String id, Double value) {
        this.id= id;
        this.value = value;

    }



    public String getId() {
        return id;
    }
    public Double getvalue() {
        return value;
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof Sensor)) {
            return false;
        }
        Sensor sensor = (Sensor) o;
        return Objects.equals(id, sensor.id);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(id);
    }

    @Override
    public String toString() {
        return "Sensor{" +
                "id='" + id + '\'' +
                ", value=" + value +

                '}';
    }

}
