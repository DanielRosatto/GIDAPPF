###########################################################################
# Universidad Nacional Arturo Jauretche                                   #
# Instituto de Ingeniería y Agronomía -Ingeniería en Informática          #
# Práctica Profesional Supervisada Nro 12 - Segundo cuatrimestre de 2018  #
#    <<Gestión Integral de Alumnos Para el Proyecto Fines>>               #
# Tutores:                                                                #
#    - UNAJ: Dr. Ing. Morales, Martín                                     #
#    - ORGANIZACIÓN: Ing. Cortes Bracho, Oscar                            #
#    - ORGANIZACIÓN: Mg. Ing. Diego Encinas                               #
#    - TAPTA: Dra. Ferrari, Mariela                                       #
# Autor: Ap. Daniel Rosatto <danielrosatto@gmail.com>                     #
# Archivo GIDAPPF/gidappf/app/models/document.rb                          #
###########################################################################
class Document < ApplicationRecord
  #####################################################################
  # Asociación muchos a uno:soporta muchos documentos pertenecientes  #
  #                         a un usuario.                             #
  #####################################################################
  belongs_to :user

  ####################################################################
  # Asociación muchos a uno:soporta muchos documentos pertenecientes #
  #                         a un perfil                              #
  ####################################################################
  belongs_to :profile

  ####################################################################
  # Asociación muchos a uno:soporta muchos documentos pertenecientes #
  #                         a un perfil                              #
  ####################################################################
  belongs_to :input

  #######################################################################################
  # Implementa la inicialización de perfiles documentados.                              #
  # Prerequisitos:                                                                      #
  #           1) Modelo de datos inicializado.                                          #
  #           2) Profile destino.                                                       #
  #           3) Usuario destino.                                                       #
  # Devolución:  Inicializa la documentación del proxile vinculado con el user mediante #
  #           documento con entrada igual a la de self.                                 #
  #######################################################################################
  def send_copy_first_document_to(profile,user)
    Document.new(profile: profile, user: user, input: copy_of_input).save
  end

  private

  ###################################################################################
  # Método privado: implementa la copia de input de documentos a partir de self.    #
  # Prerequisitos:                                                                  #
  #           1) Modelo de datos inicializado.                                      #
  #           2) Asociacion un Input a muchos InfoKey registrada en el modelo.      #
  #           3) Asociacion un InfoKey a muchos InfoValue registrada en el modelo.  #
  # Devolución: copia de self.input con todos los nested attributes.                #
  ###################################################################################
  def copy_of_input
    out = Input.new(
      title: self.input.title, summary: self.input.summary,
      grouping: self.input.grouping, enable: self.input.enable,
      author: self.input.author
    )
    self.input.info_keys.each do |k|
      out_key = out.info_keys.build(
        :key => k.key, :client_side_validator => k.client_side_validator
      )
      k.info_values.each do |v|
        out_key.info_values.build(:value => v.value)
      end
    end
    out.save
    out
  end

end
