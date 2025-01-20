<?php
//gen 25/2/2024 22:21:38 dst
class alm_tblingresoegreso_Ctrl
{
public $M_Usuariologueado = null;public function __construct()
{
$this->M_Usuariologueado = new M_Usuariologueado();
}

public function selingresoegreso($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'selingresoegreso',$f3)) {
$pCampo0 = is_null($f3->get('POST.pCampo0')) ? 'T' : $f3->get('POST.pCampo0');
$pValor0 = is_null($f3->get('POST.pValor0')) ? '' : $f3->get('POST.pValor0');
$pCampo1 = is_null($f3->get('POST.pCampo1')) ? 'T' : $f3->get('POST.pCampo1');
$pValor1 = is_null($f3->get('POST.pValor1')) ? '' : $f3->get('POST.pValor1');
$pCampo2 = is_null($f3->get('POST.pCampo2')) ? 'T' : $f3->get('POST.pCampo2');
$pValor2 = is_null($f3->get('POST.pValor2')) ? '' : $f3->get('POST.pValor2');
$pCampo3 = is_null($f3->get('POST.pCampo3')) ? 'T' : $f3->get('POST.pCampo3');
$pValor3 = is_null($f3->get('POST.pValor3')) ? '' : $f3->get('POST.pValor3');
$pCampo4 = is_null($f3->get('POST.pCampo4')) ? 'T' : $f3->get('POST.pCampo4');
$pValor4 = is_null($f3->get('POST.pValor4')) ? '' : $f3->get('POST.pValor4');
$pCampo5 = is_null($f3->get('POST.pCampo5')) ? 'T' : $f3->get('POST.pCampo5');
$pValor5 = is_null($f3->get('POST.pValor5')) ? '' : $f3->get('POST.pValor5');
$pCampo6 = is_null($f3->get('POST.pCampo6')) ? 'T' : $f3->get('POST.pCampo6');
$pValor6 = is_null($f3->get('POST.pValor6')) ? '' : $f3->get('POST.pValor6');
$pCampo7 = is_null($f3->get('POST.pCampo7')) ? 'T' : $f3->get('POST.pCampo7');
$pValor7 = is_null($f3->get('POST.pValor7')) ? '' : $f3->get('POST.pValor7');
$oDav_Ctrol = new _Dav_Ctrol();
$Con = $oDav_Ctrol->fnDevuelveConsulta('alm_visingresoegreso' , $pCampo0  , $pValor0  , $pCampo1  , $pValor1  , $pCampo2  , $pValor2  , $pCampo3  , $pValor3  , $pCampo4  , $pValor4  , $pCampo5  , $pValor5  , $pCampo6  , $pValor6  , $pCampo7  , $pValor7 );
$sql = $Con;
try {
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '200';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '500';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
}
} else {
 $msg = '201';
$items = '';
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
}
}

public function addingresoegreso($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'addingresoegreso',$f3)) {
$Tipo = 'C';
$idingresoegreso = is_null($f3->get('POST.pidingresoegreso')) ? 'T' : $f3->get('POST.pidingresoegreso');
$descripcion = is_null($f3->get('POST.pdescripcion')) ? 'T' : $f3->get('POST.pdescripcion');
$fechaingresoegreso = is_null($f3->get('POST.pfechaingresoegreso')) ? 'T' : $f3->get('POST.pfechaingresoegreso');
$idplandecuenta = is_null($f3->get('POST.pidplandecuenta')) ? 'T' : $f3->get('POST.pidplandecuenta');
$monto = is_null($f3->get('POST.pmonto')) ? 'T' : $f3->get('POST.pmonto');
$idmoneda = is_null($f3->get('POST.pidmoneda')) ? 'T' : $f3->get('POST.pidmoneda');
$idtipopago = is_null($f3->get('POST.pidtipopago')) ? 'T' : $f3->get('POST.pidtipopago');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$idcierrecaja = is_null($f3->get('POST.pidcierrecaja')) ? 'T' : $f3->get('POST.pidcierrecaja');
$sql = "CALL alm_pagingresoegreso('" . $Tipo . "','". $idingresoegreso . "','". $descripcion . "','". $fechaingresoegreso . "','". $idplandecuenta . "','". $monto . "','". $idmoneda . "','". $idtipopago . "','". $idusuario . "','". $idoficina . "','". $idcierrecaja. "'); "; 
try {
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '200';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '500';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
}
} else {
 $msg = '201';
$items = '';
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
}
}

public function getingresoegreso($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'getingresoegreso',$f3)) {
$Tipo = 'R';
$idingresoegreso = is_null($f3->get('POST.pidingresoegreso')) ? 'T' : $f3->get('POST.pidingresoegreso');
$descripcion = is_null($f3->get('POST.pdescripcion')) ? 'T' : $f3->get('POST.pdescripcion');
$fechaingresoegreso = is_null($f3->get('POST.pfechaingresoegreso')) ? 'T' : $f3->get('POST.pfechaingresoegreso');
$idplandecuenta = is_null($f3->get('POST.pidplandecuenta')) ? 'T' : $f3->get('POST.pidplandecuenta');
$monto = is_null($f3->get('POST.pmonto')) ? 'T' : $f3->get('POST.pmonto');
$idmoneda = is_null($f3->get('POST.pidmoneda')) ? 'T' : $f3->get('POST.pidmoneda');
$idtipopago = is_null($f3->get('POST.pidtipopago')) ? 'T' : $f3->get('POST.pidtipopago');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$idcierrecaja = is_null($f3->get('POST.pidcierrecaja')) ? 'T' : $f3->get('POST.pidcierrecaja');
$sql = "CALL alm_pagingresoegreso('" . $Tipo . "','". $idingresoegreso . "','". $descripcion . "','". $fechaingresoegreso . "','". $idplandecuenta . "','". $monto . "','". $idmoneda . "','". $idtipopago . "','". $idusuario . "','". $idoficina . "','". $idcierrecaja. "'); "; 
try {
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '200';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '500';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
}
} else {
 $msg = '201';
$items = '';
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
}
}

public function updingresoegreso($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'updingresoegreso',$f3)) {
$Tipo = 'U';
$idingresoegreso = is_null($f3->get('POST.pidingresoegreso')) ? 'T' : $f3->get('POST.pidingresoegreso');
$descripcion = is_null($f3->get('POST.pdescripcion')) ? 'T' : $f3->get('POST.pdescripcion');
$fechaingresoegreso = is_null($f3->get('POST.pfechaingresoegreso')) ? 'T' : $f3->get('POST.pfechaingresoegreso');
$idplandecuenta = is_null($f3->get('POST.pidplandecuenta')) ? 'T' : $f3->get('POST.pidplandecuenta');
$monto = is_null($f3->get('POST.pmonto')) ? 'T' : $f3->get('POST.pmonto');
$idmoneda = is_null($f3->get('POST.pidmoneda')) ? 'T' : $f3->get('POST.pidmoneda');
$idtipopago = is_null($f3->get('POST.pidtipopago')) ? 'T' : $f3->get('POST.pidtipopago');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$idcierrecaja = is_null($f3->get('POST.pidcierrecaja')) ? 'T' : $f3->get('POST.pidcierrecaja');
$sql = "CALL alm_pagingresoegreso('" . $Tipo . "','". $idingresoegreso . "','". $descripcion . "','". $fechaingresoegreso . "','". $idplandecuenta . "','". $monto . "','". $idmoneda . "','". $idtipopago . "','". $idusuario . "','". $idoficina . "','". $idcierrecaja. "'); "; 
try {
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '200';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '500';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
}
} else {
 $msg = '201';
$items = '';
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
}
}

public function papingresoegreso($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'papingresoegreso',$f3)) {
$Tipo = is_null($f3->get('POST.tipo')) ? 'T' : $f3->get('POST.tipo');
$procedure = is_null($f3->get('POST.procedure')) ? 'T' : $f3->get('POST.procedure');
$idingresoegreso = is_null($f3->get('POST.pidingresoegreso')) ? 'T' : $f3->get('POST.pidingresoegreso');
$descripcion = is_null($f3->get('POST.pdescripcion')) ? 'T' : $f3->get('POST.pdescripcion');
$fechaingresoegreso = is_null($f3->get('POST.pfechaingresoegreso')) ? 'T' : $f3->get('POST.pfechaingresoegreso');
$idplandecuenta = is_null($f3->get('POST.pidplandecuenta')) ? 'T' : $f3->get('POST.pidplandecuenta');
$monto = is_null($f3->get('POST.pmonto')) ? 'T' : $f3->get('POST.pmonto');
$idmoneda = is_null($f3->get('POST.pidmoneda')) ? 'T' : $f3->get('POST.pidmoneda');
$idtipopago = is_null($f3->get('POST.pidtipopago')) ? 'T' : $f3->get('POST.pidtipopago');
$idusuario = is_null($f3->get('POST.pidusuario')) ? 'T' : $f3->get('POST.pidusuario');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$idcierrecaja = is_null($f3->get('POST.pidcierrecaja')) ? 'T' : $f3->get('POST.pidcierrecaja');
$sql = "CALL " . $procedure . "('" . $Tipo . "','". $idingresoegreso . "','". $descripcion . "','". $fechaingresoegreso . "','". $idplandecuenta . "','". $monto . "','". $idmoneda . "','". $idtipopago . "','". $idusuario . "','". $idoficina . "','". $idcierrecaja. "'); "; 
try {
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '200';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
$resulto = $f3->get('DB')->exec($sql);
$items = array();
$msg = '500';
$items = $resulto;
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
} catch (PDOException $e) {
echo json_encode('{"error" : { "text":' . $e->getMessage() . '}');
}
} else {
 $msg = '201';
$items = '';
echo json_encode([
'mesaje' => $msg,
'info' => [
'item' => $items
]
]);
}
}
}
