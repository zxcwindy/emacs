(defvar zxc-bootstrap-doc-hash)

(defvar zxc-bootstrap-doc-css)

(setq zxc-bootstrap-doc-hash (make-hash-table :size 500 :test (quote equal)))

(setq zxc-bootstrap-doc-css (quote nil))

(push "container" zxc-bootstrap-doc-css)
(puthash "container"  "for a responsive fixed width container." zxc-bootstrap-doc-hash)

(push ".container-fluid" zxc-bootstrap-doc-css)
(puthash ".container-fluid"  "for a full width container, spanning the entire width of your viewport." zxc-bootstrap-doc-hash)

(push ".row" zxc-bootstrap-doc-css)
(puthash ".row"  "Rows must be placed within a .container (fixed-width) or .container-fluid (full-width) for proper alignment and padding." zxc-bootstrap-doc-hash)

(push ".col-xs-" zxc-bootstrap-doc-css)
(puthash ".col-xs-"  "Container width 	None (auto) 
12 columns" zxc-bootstrap-doc-hash)

;; ".col-sm-" "Container width 750px column with ~62px"
;; ".col-md-" "Container width 970px column with ~81px"
;; ".col-lg-" "Container width 1170px column with ~97px"
;; ".col-md-offset-" "increase the left margin of a column by * columns. 
;; For example, .col-md-offset-4 moves .col-md-4 over four columns."

;; "text-left" " Left aligned text."
;; "text-center" " Center aligned text."
;; "text-right" " Right aligned text."
;; "text-justify" " Justified text>"
;; "text-nowrap"  "No wrap text."

;; "text-lowercase" "Lowercased text."
;; "text-uppercase" "Uppercased text."
;; "text-capitalize" "Capitalized text."

;; ".table" "For basic styling—light padding and only horizontal dividers"
;; ".table-striped" "to add zebra-striping to any table row within the <tbody>.
;; Striped tables are styled via the :nth-child CSS selector, which is not available in Internet Explorer 8."
;; ".table-bordered" "for borders on all sides of the table and cells."
;; ".table-hover" "to enable a hover state on table rows within a <tbody>"

;; ".table-condensed" "to make tables more compact by cutting cell padding in half."

;; ".active" 	"Applies the hover color to a particular row or cell"
;; ".success" 	"Indicates a successful or positive action"
;; ".info" 	"Indicates a neutral informative change or action"
;; ".warning" 	"Indicates a warning that might need attention"
;; ".danger" 	"Indicates a dangerous or potentially negative action"

;; ".table-responsive" "Create responsive tables by wrapping any .table in .table-responsive to make them scroll horizontally on small devices (under 768px).
;; <div class=\"table-responsive\">
;;   <table class=\"table\">
;;     ...
;;   </table>
;; </div>"

;; ".form-control" "All textual <input>, <textarea>, and <select> elements with .form-control are set to width: 100%"

;; ".form-group" "Individual form controls automatically receive some global styling. All textual <input>, <textarea>, and <select> elements with .form-control are set to width: 100%; by default. Wrap labels and controls in .form-group for optimum spacing."
;; ".form-inline"  "Add .form-inline to your <form> for left-aligned and inline-block controls. This only applies to forms within viewports that are at least 768px wide.
;; Screen readers will have trouble with your forms if you don't include a label for every input. For these inline forms, you can hide the labels using the .sr-only class.
;; <form class=\"form-inline\" role=\"form\">
;;   <div class=\"form-group\">
;;     <label class=\"sr-only\" for=\"exampleInputEmail2\">Email address</label>
;;     <input type=\"email\" class=\"form-control\" id=\"exampleInputEmail2\" placeholder=\"Enter email\">
;;   </div>
;; ...
;; </form>
;; "

;; ".form-horizontal" "Use Bootstrap's predefined grid classes to align labels and groups of form controls in a horizontal layout by adding .form-horizontal to the form. Doing so changes .form-groups to behave as grid rows, so no need for .row."

;; ".disabled" "To have the <label> for the checkbox or radio also display a \"not-allowed\" cursor when the user hovers over the label, add the .disabled class to your .radio, .radio-inline, .checkbox, .checkbox-inline, or <fieldset>."

;; ".checkbox-inline"  "Use the .checkbox-inline or .radio-inline classes on a series of checkboxes or radios for controls that appear on the same line.
;; <label class=\"checkbox-inline\">
;;   <input type=\"checkbox\" id=\"inlineCheckbox1\" value=\"option1\"> 1
;; </label> "

;; ".radio-inline"  "Use the .checkbox-inline or .radio-inline classes on a series of checkboxes or radios for controls that appear on the same line.
;; <label class=\"checkbox-inline\">
;;   <input type=\"checkbox\" id=\"inlineCheckbox1\" value=\"option1\"> 1
;; </label>"

;; ".form-control-static" "When you need to place plain text next to a form label within a horizontal form, use the .form-control-static class on a <p>.
;; <form class=\"form-horizontal\" role=\"form\">
;;   <div class=\"form-group\">
;;     <label class=\"col-sm-2 control-label\">Email</label>
;;     <div class=\"col-sm-10\">
;;       <p class=\"form-control-static\">email@example.com</p>
;;     </div>
;;   </div>
;;   <div class=\"form-group\">
;;     <label for=\"inputPassword\" class=\"col-sm-2 control-label\">Password</label>
;;     <div class=\"col-sm-10\">
;;       <input type=\"password\" class=\"form-control\" id=\"inputPassword\" placeholder=\"Password\">
;;     </div>
;;   </div>
;; </form>"

;; ".has-warning" "Bootstrap includes validation styles for error, warning, and success states on form controls. To use, add .has-warning, .has-error, or .has-success to the parent element. Any .control-label, .form-control, and .help-block within that element will receive the validation styles."
;; ".has-error" "Bootstrap includes validation styles for error, warning, and success states on form controls. To use, add .has-warning, .has-error, or .has-success to the parent element. Any .control-label, .form-control, and .help-block within that element will receive the validation styles."

;; ".has-success" "Bootstrap includes validation styles for error, warning, and success states on form controls. To use, add .has-warning, .has-error, or .has-success to the parent element. Any .control-label, .form-control, and .help-block within that element will receive the validation styles."

;; ".has-feedback" "You can also add optional feedback icons with the addition of .has-feedback and the right icon."

;; ".input-lg" "Set heights using classes like .input-lg"

;; ".col-lg-" "set widths using grid column classes like .col-lg-*."

;; ".form-group-lg" "Quickly size labels and form controls within .form-horizontal by adding .form-group-lg"
;; ".form-group-sm" "Quickly size labels and form controls within .form-horizontal by adding .form-group-sm."
;; ".help-block" "Block level help text for form controls."
;; ".btn" "Use any of the available button classes to quickly create a styled button."

;; "btn-default" "Default"
;; "btn-primary" "Primary"
;; "btn-success" "Success"
;; "btn-info" "Info"
;; "btn-warning" "Warning"
;; "btn-danger" "Danger"
;; "btn-link" "Link"

;; ".btn-lg" "large button"
;; ".btn-sm" "small button"
;; ".btn-xs" "extra small button"

;; ".btn-block" "Create block level buttons—those that span the full width of a parent"

;; ".active" "Add the .active class to <a> buttons. or <button> buttons"

;; ".img-responsive" "Images in Bootstrap 3 can be made responsive-friendly via the addition of the .img-responsive class."

;; ".img-rounded" "image style"
;; ".img-circle" "image style"
;; ".img-thumbnail" "image style"

;; ".text-muted" "muted"
;; ".text-primary" "primary"
;; ".text-success" "success"
;; ".text-info" "info"
;; ".text-warning" "warning"
;; ".text-danger" "danger"

;; ".bg-primary" "background primary"
;; ".bg-success" "background success"
;; ".bg-info" "background info"
;; ".bg-warning" "background warning"
;; ".bg-danger" "background danger"

;; ".close" "Use the generic close icon for dismissing content like modals and alerts."
;; ".caret" "Use carets to indicate dropdown functionality and direction. Note that the default caret will reverse automatically in dropup menus."

;; ".pull-left" "Float an element to the left with a class"
;; ".pull-right" "Float an element to the right with a class"

;; ".center-block" "Set an element to display: block and center via margin. Available as a mixin and class."

;; ".clearfix" "Easily clear floats by adding .clearfix to the parent element. "

;; ".show" "Force an element to be shown"
;; ".hidden" "Force an element to be hidden"
;; ".text-hide" "Utilize the .text-hide class or mixin to help replace an element's text content with a background image."

;; ".btn-group" "Wrap a series of buttons with .btn in .btn-group."
;; ".btn-toolbar" "Combine sets of <div class=\"btn-group\"> into a <div class=\"btn-toolbar\"> for more complex components."
;; ".btn-group-vertical" "Make a set of buttons appear vertically stacked rather than horizontally. Split button dropdowns are not supported here."
;; ".btn-group-justified" "Just wrap a series of .btns in .btn-group.btn-group-justified.
;; To use justified button groups with <button> elements, you must wrap each button in a button group. Most browsers don't properly apply our CSS for justification to <button> elements, but since we support button dropdowns, we can workaround that."
