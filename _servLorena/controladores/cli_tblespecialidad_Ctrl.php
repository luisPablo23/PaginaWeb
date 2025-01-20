<?php
//gen 25/2/2024 22:21:51 dst
class cli_tblespecialidad_Ctrl
{
public $M_Usuariologueado = null;public function __construct()
{
$this->M_Usuariologueado = new M_Usuariologueado();
}

public function selespecialidad($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'selespecialidad',$f3)) {
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
$Con = $oDav_Ctrol->fnDevuelveConsulta('cli_visespecialidad' , $pCampo0  , $pValor0  , $pCampo1  , $pValor1  , $pCampo2  , $pValor2  , $pCampo3  , $pValor3  , $pCampo4  , $pValor4  , $pCampo5  , $pValor5  , $pCampo6  , $pValor6  , $pCampo7  , $pValor7 );
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

public function addespecialidad($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'addespecialidad',$f3)) {
$Tipo = 'C';
$idespecialidad = is_null($f3->get('POST.pidespecialidad')) ? 'T' : $f3->get('POST.pidespecialidad');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$nombreespecialidad = is_null($f3->get('POST.pnombreespecialidad')) ? 'T' : $f3->get('POST.pnombreespecialidad');
$titulo = is_null($f3->get('POST.ptitulo')) ? 'T' : $f3->get('POST.ptitulo');
$detalle = is_null($f3->get('POST.pdetalle')) ? 'T' : $f3->get('POST.pdetalle');
$pieespecialidad = is_null($f3->get('POST.ppieespecialidad')) ? 'T' : $f3->get('POST.ppieespecialidad');
$orden = is_null($f3->get('POST.porden')) ? 'T' : $f3->get('POST.porden');
$agendarcita = is_null($f3->get('POST.pagendarcita')) ? 'T' : $f3->get('POST.pagendarcita');
$sql = "CALL cli_pagespecialidad('" . $Tipo . "','". $idespecialidad . "','". $idoficina . "','". $nombreespecialidad . "','". $titulo . "','". $detalle . "','". $pieespecialidad . "','". $orden . "','". $agendarcita. "'); "; 
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

public function getespecialidad($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'getespecialidad',$f3)) {
$Tipo = 'R';
$idespecialidad = is_null($f3->get('POST.pidespecialidad')) ? 'T' : $f3->get('POST.pidespecialidad');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$nombreespecialidad = is_null($f3->get('POST.pnombreespecialidad')) ? 'T' : $f3->get('POST.pnombreespecialidad');
$titulo = is_null($f3->get('POST.ptitulo')) ? 'T' : $f3->get('POST.ptitulo');
$detalle = is_null($f3->get('POST.pdetalle')) ? 'T' : $f3->get('POST.pdetalle');
$pieespecialidad = is_null($f3->get('POST.ppieespecialidad')) ? 'T' : $f3->get('POST.ppieespecialidad');
$orden = is_null($f3->get('POST.porden')) ? 'T' : $f3->get('POST.porden');
$agendarcita = is_null($f3->get('POST.pagendarcita')) ? 'T' : $f3->get('POST.pagendarcita');
$sql = "CALL cli_pagespecialidad('" . $Tipo . "','". $idespecialidad . "','". $idoficina . "','". $nombreespecialidad . "','". $titulo . "','". $detalle . "','". $pieespecialidad . "','". $orden . "','". $agendarcita. "'); "; 
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

public function updespecialidad($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'updespecialidad',$f3)) {
$Tipo = 'U';
$idespecialidad = is_null($f3->get('POST.pidespecialidad')) ? 'T' : $f3->get('POST.pidespecialidad');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$nombreespecialidad = is_null($f3->get('POST.pnombreespecialidad')) ? 'T' : $f3->get('POST.pnombreespecialidad');
$titulo = is_null($f3->get('POST.ptitulo')) ? 'T' : $f3->get('POST.ptitulo');
$detalle = is_null($f3->get('POST.pdetalle')) ? 'T' : $f3->get('POST.pdetalle');
$pieespecialidad = is_null($f3->get('POST.ppieespecialidad')) ? 'T' : $f3->get('POST.ppieespecialidad');
$orden = is_null($f3->get('POST.porden')) ? 'T' : $f3->get('POST.porden');
$agendarcita = is_null($f3->get('POST.pagendarcita')) ? 'T' : $f3->get('POST.pagendarcita');
$sql = "CALL cli_pagespecialidad('" . $Tipo . "','". $idespecialidad . "','". $idoficina . "','". $nombreespecialidad . "','". $titulo . "','". $detalle . "','". $pieespecialidad . "','". $orden . "','". $agendarcita. "'); "; 
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

public function papespecialidad($f3)
{
$idusuario = is_null($f3->get('POST.idusuario')) ? 'T' : $f3->get('POST.idusuario');
$llave = is_null($f3->get('POST.llave')) ? 'T' : $f3->get('POST.llave');
if ($this->M_Usuariologueado->ValidaSession($idusuario, $llave,'papespecialidad',$f3)) {
$Tipo = is_null($f3->get('POST.tipo')) ? 'T' : $f3->get('POST.tipo');
$procedure = is_null($f3->get('POST.procedure')) ? 'T' : $f3->get('POST.procedure');
$idespecialidad = is_null($f3->get('POST.pidespecialidad')) ? 'T' : $f3->get('POST.pidespecialidad');
$idoficina = is_null($f3->get('POST.pidoficina')) ? 'T' : $f3->get('POST.pidoficina');
$nombreespecialidad = is_null($f3->get('POST.pnombreespecialidad')) ? 'T' : $f3->get('POST.pnombreespecialidad');
$titulo = is_null($f3->get('POST.ptitulo')) ? 'T' : $f3->get('POST.ptitulo');
$detalle = is_null($f3->get('POST.pdetalle')) ? 'T' : $f3->get('POST.pdetalle');
$pieespecialidad = is_null($f3->get('POST.ppieespecialidad')) ? 'T' : $f3->get('POST.ppieespecialidad');
$orden = is_null($f3->get('POST.porden')) ? 'T' : $f3->get('POST.porden');
$agendarcita = is_null($f3->get('POST.pagendarcita')) ? 'T' : $f3->get('POST.pagendarcita');
$sql = "CALL " . $procedure . "('" . $Tipo . "','". $idespecialidad . "','". $idoficina . "','". $nombreespecialidad . "','". $titulo . "','". $detalle . "','". $pieespecialidad . "','". $orden . "','". $agendarcita. "'); "; 
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
