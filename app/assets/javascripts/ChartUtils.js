(function (expose) {
    var ChartUtils = {};

    ChartUtils.SITUATIONS_COLORS = {
        'APROVADO': '#109618',
        'REPROVADO': '#DC3912',
        'MATRICULADO': '#3366CC',
        'TRANCADO': '#FF9900',
        'DISPENSADO': '#949BA2',
        'REP. FALTA': '#8B0707'
    };

    ChartUtils.getSituationsColors = function (situations) {
        var colors = [];
        situations.forEach(function (situation) {
           colors.push(ChartUtils.SITUATIONS_COLORS[situation]);
        });
        return colors;
    };

    expose.ChartUtils = ChartUtils;
})(window);
