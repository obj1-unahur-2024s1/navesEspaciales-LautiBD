class Nave{
	
	var property velocidad
	
	var property direccionAlSol  /* --> revisar */
	
	var property combustible
	
	
	method acelerar(cant){velocidad = 100000.min(velocidad + cant)}
	
	method desacelerar(cant){velocidad = 0.max(velocidad - cant)}
	
	method irHaciaElSol() {direccionAlSol = 10}
	
	method escaparDelSol(){direccionAlSol = -10}
	
	method ponerseParaleloAlSol(){direccionAlSol = 0}
	
	method acercarseUnPocoAlSol(){direccionAlSol = 10.min(direccionAlSol + 1)}
	
	method alejarseUnPocoDelSol(){direccionAlSol = 0.max(direccionAlSol - 1)}
	
	method cargarCombustible(cant){combustible += cant}
	
	method descargarCombustible(cant){combustible = 0.max(combustible - cant)}

	method prepararViaje() {self.cargarCombustible(30000)
							self.acelerar(5000)
	}
	
	method estaTranquila() = self.combustible() >= 4000 and self.velocidad() <= 12000

	method escapar()
	
	method avisar()

	method recibirAmenaza(){self.escapar()
						    self.avisar()}
						    
	method tenerPocaActividad()
						    
	method estaRelajo() = self.estaTranquila() and self.tenerPocaActividad()

}


class NaveBaliza inherits Nave{
	
	var property balizaQueMuestra
	var contador = 0
	const property coloresBaliza = ["verde","rojo","azul"]
	
	method cambiarColorBaliza(color){balizaQueMuestra = color
									contador += 1
	}
	
	override method prepararViaje() {super()
									self.cambiarColorBaliza("verde") 
									self.ponerseParaleloAlSol()
	}
	
	override method estaTranquila() = super() and balizaQueMuestra != "rojo"
	
	override method escapar(){self.irHaciaElSol()}
	
	override method avisar(){self.cambiarColorBaliza("rojo")}
	
	override method tenerPocaActividad(){contador = 0}
		
}

class NaveDePasajeros inherits Nave{
	
	var property cantPasajeros
	
	var property racionComida
	
	var contadorRacionesDadas = 0
	
	var property racionBebida
	
	method cargarComida(cant) {racionComida += cant}
	method descargarComida(cant) {racionComida = 0.max(racionComida -= cant)
								 contadorRacionesDadas += cant	
	}
	
	
	method cargarBebida(cant) {racionBebida += cant}
	method descargarBebida(cant) {racionBebida = 0.max(racionBebida -= cant)}
	
	override method prepararViaje(){super()
									self.cargarComida(4 * cantPasajeros)
									self.cargarBebida(6 * cantPasajeros)
									self.acercarseUnPocoAlSol()
	}
	
	override method escapar(){velocidad = velocidad * 2}
	override method avisar() {self.descargarComida(cantPasajeros)
							  self.descargarBebida(cantPasajeros * 2)
	}
	
	override method tenerPocaActividad() = contadorRacionesDadas < 50
}


class NaveDeCombate inherits Nave{
	
	var estaVisible = true
	var property misilesDesplegados = false
	
	const mensajesEmitidos = []
	
	method ponerseVisible(){estaVisible = true}
	
	method ponerseInvisible(){estaVisible = false}
	
	method estaVisible() = estaVisible
	
	method desplegarMisiles(){misilesDesplegados = true}
	
	method replegarMisiles(){misilesDesplegados = false}
	
	method emitirMensaje(mensaje) = mensajesEmitidos.add(mensaje)
	
	method mensajesEmitidos() = mensajesEmitidos.size()
	
	method primerMensajeEmitido() = mensajesEmitidos.first()
	
	method ultimoMensajeEmitido() = mensajesEmitidos.last()
	
	method esEscueta() = not mensajesEmitidos.all({mensaje => mensaje.size() > 30})
	
	method emitioMensaje(mensaje) = mensajesEmitidos.contains(mensaje)
	
	override method prepararViaje(){super()
									self.ponerseVisible()
									self.replegarMisiles()
									self.acelerar(15000)
	}
	
	override method estaTranquila() = super() and not misilesDesplegados
	
	override method escapar(){self.acercarseUnPocoAlSol()
							  self.acercarseUnPocoAlSol()	
	}
	
	override method avisar() = self.emitirMensaje("AmenazaRecibida")
	
	override method tenerPocaActividad() = self.esEscueta()
	
	
}

class NaveHospital inherits NaveDePasajeros{
	
	var property estanPreparadosLosQuirofanos
	
	override method estaTranquila() = super() and not estanPreparadosLosQuirofanos
	
	method prepararQuirofanos() {estanPreparadosLosQuirofanos = true}
	
	override method recibirAmenaza(){super()
									self.prepararQuirofanos()
	}
}

class NaveDeCombateSigilosa inherits NaveDeCombate{
	
	override method estaTranquila() = super() and self.estaVisible()
	
	override method recibirAmenaza(){super()
									self.desplegarMisiles()		
									self.ponerseInvisible()
	}
		
	
	
	
}