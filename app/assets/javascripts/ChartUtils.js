(function (expose) {
    var ChartUtils = {};

    ChartUtils.SITUATIONS_COLORS = {
        'APROVADO': '#0000FF',
        'REPROVADO': '#FF0000',
        'MATRICULADO': '#FFFF00',
        'TRANCADO': '#808080',
        'DISPENSADO': '#00FF00',
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
