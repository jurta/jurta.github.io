/*
 * jQuery Table of Content Generator for Markdown v1.0
 *
 * https://github.com/dafi/tocmd-generator
 * Examples and documentation at: https://github.com/dafi/tocmd-generator
 *
 * Requires: jQuery v1.7+
 *
 * Copyright (c) 2013 Davide Ficano
 *
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 */
(function($) {
    var toggleHTML = '<div id="toctitle"><h2>%1</h2></div>';
    var tocContainerHTML = '<div id="toc-container"><table class="toc" id="toc"><tbody><tr><td>%1<ul>%2</ul></td></tr></tbody></table></div>';

    function createLevelHTML(anchorId, tocLevel, tocSection, tocNumber, tocText, tocInner) {
        var link = '<a href="#%1"><span class="tocnumber">%2</span> <span class="toctext">%3</span></a>%4'
            .replace('%1', anchorId)
            .replace('%2', tocNumber)
            .replace('%3', tocText)
            .replace('%4', tocInner ? tocInner : '');
        return '<li class="toclevel-%1 tocsection-%2">%3</li>\n'
            .replace('%1', tocLevel)
            .replace('%2', tocSection)
            .replace('%3', link);
    }

    function checkMaxHead($root) {
        return ['h2', 'h3'];
    }

    $.fn.toc = function(settings) {
        var config = {
            renderIn: 'self',
            anchorPrefix: 'tocAnchor-',
            showAlways: false,
            minItemsToShowToc: 2,
            contentsText: 'Table of contents'};

        if (settings) {
            $.extend(config, settings);
        }

        var tocHTML = '';
        var tocLevel = 1;
        var tocSection = 1;
        var itemNumber = 1;

        var tocContainer = $(this);

        var heads = checkMaxHead(tocContainer);
        var firstHead = heads[0];
        var secondHead = heads[1];

        tocContainer.find(firstHead).each(function() {
            var levelHTML = '';
            var innerSection = 0;
            var h1 = $(this);

            h1.nextUntil(firstHead).filter(secondHead).each(function() {
                ++innerSection;
                var anchorId = config.anchorPrefix + tocLevel + '-' + tocSection + '-' +  + innerSection;
                $(this).attr('id', anchorId);
                levelHTML += createLevelHTML(anchorId,
                    tocLevel + 1,
                    tocSection + innerSection,
                    itemNumber + '.' + innerSection,
                    $(this).text());
            });
            if (levelHTML) {
                levelHTML = '<ul>' + levelHTML + '</ul>\n';
            }
            var anchorId = config.anchorPrefix + tocLevel + '-' + tocSection;
            h1.attr('id', anchorId);
            tocHTML += createLevelHTML(anchorId,
                tocLevel,
                tocSection,
                itemNumber,
                h1.text(),
                levelHTML);

            tocSection += 1 + innerSection;
            ++itemNumber;
        });

        // for convenience itemNumber starts from 1
        // so we decrement it to obtain the index count
        var tocIndexCount = itemNumber - 1;

        var show = config.showAlways ? true : config.minItemsToShowToc <= tocIndexCount;

        if (show && tocHTML) {
            var replacedToggleHTML = toggleHTML
                .replace('%1', config.contentsText);
            var replacedTocContainer = tocContainerHTML
                .replace('%1', replacedToggleHTML)
                .replace('%2', tocHTML);

            // Renders in default or specificed path
            if (config.renderIn != 'self') {
              $(config.renderIn).html(replacedTocContainer);
            } else {
              tocContainer.prepend(replacedTocContainer);
            }
        }
        return this;
    }
})(jQuery);

$( document ).ready(function() {
  $('#main').toc({
    renderIn: '#toc'
  });
});
