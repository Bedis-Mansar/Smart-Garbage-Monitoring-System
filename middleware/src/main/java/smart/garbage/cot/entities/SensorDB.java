package smart.garbage.cot.entities;

import jakarta.nosql.mapping.Column;
import jakarta.nosql.mapping.Entity;
import jakarta.nosql.mapping.Id;
import jakarta.json.bind.annotation.JsonbVisibility;
import java.io.Serializable;
import java.util.Objects;
@Entity
@JsonbVisibility(FieldPropertyVisibilityStrategy.class)
public class SensorDB implements Serializable  { // Sensor entity for the geolocation services
    @Id
    private String id;

    @Column
    private Double longitude;

    @Column
    private Double latitude;

    public SensorDB() {
    }

    public SensorDB(String id, Double longitude, Double latitude) {
        this.id= id;
        this.longitude = longitude;
        this.latitude = latitude;

    }



    public String getId() {
        return id;
    }



    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof SensorDB)) {
            return false;
        }
        SensorDB sensor = (SensorDB) o;
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
                ", longitude=" + longitude +
                ", longitude=" + latitude +

                '}';
    }

}
