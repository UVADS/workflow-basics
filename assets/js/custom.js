// Custom JavaScript for code blocks: copy-to-clipboard and collapsible functionality

(function() {
  'use strict';

  // Configuration
  const COLLAPSED_LINES = 10; // Number of lines to show when collapsed

  // Initialize when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  function init() {
    addCopyButtons();
    makeCodeBlocksCollapsible();
  }

  // Add copy-to-clipboard buttons to all code blocks
  function addCopyButtons() {
    const codeBlocks = document.querySelectorAll('div.highlighter-rouge, figure.highlight, div.listingblock > div.content');
    
    codeBlocks.forEach(function(block) {
      // Skip if our button already exists
      if (block.querySelector('button.copy-code-button')) {
        return;
      }

      // Remove any existing default buttons (but keep toggle buttons)
      const existingButtons = block.querySelectorAll('button:not(.code-toggle-button)');
      existingButtons.forEach(function(btn) {
        // Only remove if it's not our custom button
        if (!btn.classList.contains('copy-code-button')) {
          btn.remove();
        }
      });

      // Find the code element
      const codeElement = block.querySelector('code') || block.querySelector('pre');
      if (!codeElement) return;

      // Get the code text
      const getCodeText = function() {
        // Handle line numbers - get text from code cells
        const codeCells = codeElement.querySelectorAll('td.rouge-code pre, td.code pre');
        if (codeCells.length > 0) {
          return Array.from(codeCells).map(cell => cell.textContent).join('\n');
        }
        // Regular code block
        return codeElement.textContent || codeElement.innerText;
      };

      // Create copy button
      const button = document.createElement('button');
      button.className = 'copy-code-button';
      button.setAttribute('aria-label', 'Copy code to clipboard');
      button.setAttribute('title', 'Copy code');
      button.innerHTML = `
        <svg class="copy-icon" width="14" height="14" viewBox="0 0 16 16" fill="currentColor">
          <path d="M4 1.5H3a2 2 0 0 0-2 2V14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V3.5a2 2 0 0 0-2-2h-1v1h1a1 1 0 0 1 1 1V14a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V3.5a1 1 0 0 1 1-1h1v-1z"/>
          <path d="M9.5 1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-3a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5h3zm-3-1A1.5 1.5 0 0 0 5 1.5v1A1.5 1.5 0 0 0 6.5 4h3A1.5 1.5 0 0 0 11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3z"/>
        </svg>
        <span class="copy-text">Copy</span>
      `;

      // Copy to clipboard handler
      button.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        const codeText = getCodeText();
        
        // Use modern Clipboard API if available
        if (navigator.clipboard && navigator.clipboard.writeText) {
          navigator.clipboard.writeText(codeText).then(function() {
            showCopiedFeedback(button);
          }).catch(function(err) {
            console.error('Failed to copy:', err);
            fallbackCopyTextToClipboard(codeText, button);
          });
        } else {
          fallbackCopyTextToClipboard(codeText, button);
        }
      });

      // Insert button at the beginning of the block
      block.style.position = 'relative';
      block.insertBefore(button, block.firstChild);
    });
  }

  // Fallback copy method for older browsers
  function fallbackCopyTextToClipboard(text, button) {
    const textArea = document.createElement('textarea');
    textArea.value = text;
    textArea.style.position = 'fixed';
    textArea.style.left = '-999999px';
    textArea.style.top = '-999999px';
    document.body.appendChild(textArea);
    textArea.focus();
    textArea.select();
    
    try {
      const successful = document.execCommand('copy');
      if (successful) {
        showCopiedFeedback(button);
      }
    } catch (err) {
      console.error('Fallback copy failed:', err);
    }
    
    document.body.removeChild(textArea);
  }

  // Show copied feedback
  function showCopiedFeedback(button) {
    const copyIcon = button.querySelector('.copy-icon');
    const copyText = button.querySelector('.copy-text');
    
    // Store original state
    if (!button.dataset.originalIcon) {
      button.dataset.originalIcon = copyIcon ? copyIcon.outerHTML : '';
    }
    if (!button.dataset.originalText) {
      button.dataset.originalText = copyText ? copyText.textContent : '';
    }
    
    // Update to show checkmark icon and "Copied" text
    if (copyIcon) {
      copyIcon.outerHTML = `
        <svg class="copy-icon" width="14" height="14" viewBox="0 0 16 16" fill="currentColor">
          <path d="M6.5 0A1.5 1.5 0 0 0 5 1.5v1A1.5 1.5 0 0 0 6.5 4h3A1.5 1.5 0 0 0 11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3Zm3 1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-3a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5h3Z"/>
          <path d="M4 1.5H3a2 2 0 0 0-2 2V14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V3.5a2 2 0 0 0-2-2h-1v1A2.5 2.5 0 0 1 9.5 5h-3A2.5 2.5 0 0 1 4 2.5v-1Zm6.854 7.354-3 3a.5.5 0 0 1-.708 0l-1.5-1.5a.5.5 0 0 1 .708-.708L7.5 10.793l2.646-2.647a.5.5 0 0 1 .708.708Z"/>
        </svg>
      `;
    }
    if (copyText) {
      copyText.textContent = 'Copied';
    }
    button.setAttribute('title', 'Copied!');
    button.classList.add('copied-state');
    
    setTimeout(function() {
      // Restore original icon and text
      const currentIcon = button.querySelector('.copy-icon');
      const currentText = button.querySelector('.copy-text');
      if (currentIcon && button.dataset.originalIcon) {
        currentIcon.outerHTML = button.dataset.originalIcon;
      }
      if (currentText && button.dataset.originalText) {
        currentText.textContent = button.dataset.originalText;
      }
      button.setAttribute('title', 'Copy code');
      button.classList.remove('copied-state');
    }, 2000);
  }

  // Make code blocks collapsible
  function makeCodeBlocksCollapsible() {
    const codeBlocks = document.querySelectorAll('div.highlighter-rouge, figure.highlight, div.listingblock > div.content');
    
    codeBlocks.forEach(function(block) {
      // Skip if already processed
      if (block.classList.contains('code-collapsible-processed')) {
        return;
      }
      block.classList.add('code-collapsible-processed');

      // Find the code/pre element
      const codeElement = block.querySelector('code') || block.querySelector('pre');
      if (!codeElement) return;

      // Count lines in the code
      const codeText = codeElement.textContent || codeElement.innerText;
      const lines = codeText.split('\n');
      const lineCount = lines.length;

      // Only make collapsible if it has more than COLLAPSED_LINES
      if (lineCount <= COLLAPSED_LINES) {
        return;
      }

      // Calculate exact height for COLLAPSED_LINES
      // Get computed line height
      const computedStyle = window.getComputedStyle(codeElement);
      const lineHeight = parseFloat(computedStyle.lineHeight) || parseFloat(computedStyle.fontSize) * 1.5;
      const paddingTop = parseFloat(computedStyle.paddingTop) || 0;
      const paddingBottom = parseFloat(computedStyle.paddingBottom) || 0;
      const borderTop = parseFloat(computedStyle.borderTopWidth) || 0;
      const borderBottom = parseFloat(computedStyle.borderBottomWidth) || 0;
      
      // Calculate total height for COLLAPSED_LINES
      const collapsedHeight = (lineHeight * COLLAPSED_LINES) + paddingTop + paddingBottom + borderTop + borderBottom;
      
      // Add collapsible class and set max-height directly
      block.classList.add('code-collapsible');
      block.classList.add('code-collapsed');
      block.style.maxHeight = collapsedHeight + 'px';
      block.setAttribute('data-collapsed-height', collapsedHeight + 'px'); // Store for later use

      // Create toggle button
      const toggleButton = document.createElement('button');
      toggleButton.className = 'code-toggle-button';
      toggleButton.setAttribute('aria-label', 'Expand/collapse code');
      toggleButton.setAttribute('title', 'Click to expand');
      toggleButton.innerHTML = `
        <svg width="16" height="16" viewBox="0 0 16 16" fill="currentColor">
          <path fill-rule="evenodd" d="M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z"/>
        </svg>
        <span class="toggle-text">Show more</span>
      `;

      // Toggle handler
      toggleButton.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        const isCollapsed = block.classList.contains('code-collapsed');
        
        if (isCollapsed) {
          block.classList.remove('code-collapsed');
          block.style.maxHeight = 'none';
          toggleButton.setAttribute('title', 'Click to collapse');
          toggleButton.querySelector('.toggle-text').textContent = 'Show less';
          toggleButton.querySelector('svg').style.transform = 'rotate(180deg)';
        } else {
          // Restore collapsed height
          const collapsedHeight = block.getAttribute('data-collapsed-height') || 
            (parseFloat(window.getComputedStyle(codeElement).lineHeight) * COLLAPSED_LINES + 32) + 'px';
          block.classList.add('code-collapsed');
          block.style.maxHeight = collapsedHeight;
          toggleButton.setAttribute('title', 'Click to expand');
          toggleButton.querySelector('.toggle-text').textContent = 'Show more';
          toggleButton.querySelector('svg').style.transform = 'rotate(0deg)';
        }
      });

      // Insert toggle button at the end of the block (bottom right)
      // Don't insert after copy button to avoid positioning issues
      block.appendChild(toggleButton);
    });
  }
})();

