{each, obj-to-pairs} = require \prelude-ls
{DOM:{input}, create-class, create-factory}:React = require \react
{find-DOM-node} = require \react-dom

module.exports = create-class do

    display-name: \ResizableInput

    # render :: () -> ReactElement
    render: ->
        input {} <<< @props <<< 
            type: \input
            class-name: "resizable-input #{@props?.class-name ? ''}"

    # component-did-update :: Props -> UIState -> ()
    component-did-update: (prev-props) !->

        # reset the width
        input-element = (find-DOM-node @)
            ..style.width = \0px

        if input-element.value.length == 0

            # the minimum width required for the cursor to be visible
            input-element.style.width = if !!input-element?.current-style then \4px else \2px

        else

            # modern browsers
            if input-element.scroll-width > 0
                input-element.style.width = "#{2 + input-element.scroll-width}px"

            # IE / Edge
            else

                # create a dummy input
                dummpy-input = document.create-element \div
                    ..innerHTML = input-element.value

                # copy all the styles from search field to dummy input
                (
                    if !!input-element.current-style 
                        input-element.current-style 
                    else 
                        document.default-view ? window .get-computed-style input-element
                )
                    |> obj-to-pairs
                    |> each ([key, value]) -> dummpy-input.style[key] = value
                    |> -> dummpy-input.style <<< display: \inline-block, width: ""

                # add the dummy input element to document.body and measure the text width
                document.body.append-child dummpy-input
                input-element.style.width = "#{4 + dummpy-input.client-width}px"
                document.body.remove-child dummpy-input

    # blur :: () -> ()
    blur: -> find-DOM-node @ .blur!

    # focus :: () -> ()
    focus: -> find-DOM-node @ .focus!