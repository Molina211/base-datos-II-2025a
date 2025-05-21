INDEX 

CREATE INDEX idx_hab_voluntario_id ON HabilidadesVoluntario(id_voluntario);
CREATE INDEX idx_hab_habilidad_id ON HabilidadesVoluntario(id_habilidades_voluntario);
CREATE INDEX idx_hash_hab_voluntario_id ON HabilidadesVoluntario USING HASH(id_voluntario);
CREATE INDEX idx_hash_hab_habilidad_id ON HabilidadesVoluntario USING HASH(id_habilidades_voluntario);                                                                   CREATE INDEX idx_registro_voluntario_id ON RegistroHoras(id_voluntario);