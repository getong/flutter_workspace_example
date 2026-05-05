import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

void main() {
  Jaspr.initializeApp();

  runApp(
    Document(
      title: 'Jaspr Text Field Controller Example',
      body: const TextFieldControllerJasprApp(),
    ),
  );
}

class TextFieldControllerJasprApp extends StatelessComponent {
  const TextFieldControllerJasprApp({super.key});

  @override
  Component build(BuildContext context) {
    return div(
      [
        section(
          [
            h1([Component.text('Text Field State in Jaspr')]),
            p([
              Component.text(
                'Flutter uses TextEditingController for programmatic text access. '
                'In Jaspr, the equivalent pattern is explicit component state plus '
                'input event handlers.',
              ),
            ]),
            const TextFieldControllerJasprDemo(),
          ],
          styles: _pageSectionStyles,
        ),
      ],
      styles: _pageShellStyles,
    );
  }
}

class TextFieldControllerJasprDemo extends StatefulComponent {
  const TextFieldControllerJasprDemo({super.key});

  @override
  State<TextFieldControllerJasprDemo> createState() =>
      _TextFieldControllerJasprDemoState();
}

class _TextFieldControllerJasprDemoState
    extends State<TextFieldControllerJasprDemo> {
  String name = 'Flutter learner';
  String message = '';
  String submittedMessage = 'Nothing submitted yet.';

  String sharedValue = 'Shared controller text';

  String firstSeparateValue = 'First separate value';
  String secondSeparateValue = 'Second separate value';

  @override
  Component build(BuildContext context) {
    return div(
      [
        _card(
          title: 'Live Value',
          description:
              'This input updates the preview immediately through onInput state updates.',
          children: [
            _textInput(
              labelText: 'Name',
              inputId: 'name-field',
              value: name,
              placeholder: 'Type your name',
              onInput: (value) => setState(() => name = value),
            ),
            _outputText(
              'Live preview: ${name.isEmpty ? '(empty)' : name}',
            ),
          ],
        ),
        _card(
          title: 'Control Text From Code',
          description:
              'These buttons write to the message field, submit its current value, or clear both fields.',
          children: [
            _textArea(
              labelText: 'Message',
              inputId: 'message-field',
              value: message,
              placeholder: 'Write a short message',
              onInput: (value) => setState(() => message = value),
            ),
            div(
              [
                button(
                  [Component.text('Prefill Message')],
                  onClick: () => setState(
                    () => message = 'Hello, ${name.isEmpty ? 'friend' : name}!',
                  ),
                  styles: _filledButtonStyles,
                ),
                button(
                  [Component.text('Submit Message')],
                  onClick: () => setState(
                    () => submittedMessage =
                        message.isEmpty ? 'Nothing submitted yet.' : message,
                  ),
                  styles: _outlinedButtonStyles,
                ),
                button(
                  [Component.text('Clear Fields')],
                  onClick: () => setState(() {
                    name = '';
                    message = '';
                    submittedMessage = 'Nothing submitted yet.';
                  }),
                  styles: _textButtonStyles,
                ),
              ],
              styles: _buttonRowStyles,
            ),
            _outputText('Submitted message: $submittedMessage'),
          ],
        ),
        _card(
          title: 'Two Inputs, One Shared State',
          description:
              'Both inputs read and write the same Jaspr state value, so typing in either one updates the other immediately.',
          children: [
            _textInput(
              labelText: 'Shared Field A',
              inputId: 'shared-field-a',
              value: sharedValue,
              placeholder: 'Type here',
              onInput: (value) => setState(() => sharedValue = value),
            ),
            _textInput(
              labelText: 'Shared Field B',
              inputId: 'shared-field-b',
              value: sharedValue,
              placeholder: 'The same text appears here',
              onInput: (value) => setState(() => sharedValue = value),
            ),
            _outputText(
              'Shared value: ${sharedValue.isEmpty ? '(empty)' : sharedValue}',
            ),
          ],
        ),
        _card(
          title: 'Two Inputs, Two Independent States',
          description:
              'These inputs write to different state variables, so each field keeps its own value.',
          children: [
            _textInput(
              labelText: 'Separate Field A',
              inputId: 'separate-field-a',
              value: firstSeparateValue,
              placeholder: 'First controller',
              onInput: (value) => setState(() => firstSeparateValue = value),
            ),
            _textInput(
              labelText: 'Separate Field B',
              inputId: 'separate-field-b',
              value: secondSeparateValue,
              placeholder: 'Second controller',
              onInput: (value) => setState(() => secondSeparateValue = value),
            ),
            _outputText(
              'Field A value: '
              '${firstSeparateValue.isEmpty ? '(empty)' : firstSeparateValue}',
            ),
            _outputText(
              'Field B value: '
              '${secondSeparateValue.isEmpty ? '(empty)' : secondSeparateValue}',
            ),
          ],
        ),
      ],
      styles: _stackStyles,
    );
  }

  Component _card({
    required String title,
    required String description,
    required List<Component> children,
  }) {
    return section(
      [
        h2([Component.text(title)], styles: _cardTitleStyles),
        p([Component.text(description)], styles: _descriptionStyles),
        div(children, styles: _cardBodyStyles),
      ],
      styles: _cardStyles,
    );
  }

  Component _textInput({
    required String labelText,
    required String inputId,
    required String value,
    required String placeholder,
    required void Function(String value) onInput,
  }) {
    return div(
      [
        label(
          [Component.text(labelText)],
          htmlFor: inputId,
          styles: _labelStyles,
        ),
        input<String>(
          id: inputId,
          type: InputType.text,
          value: value,
          onInput: onInput,
          styles: _inputStyles,
          attributes: {
            'autocomplete': 'off',
            'placeholder': placeholder,
          },
        ),
      ],
      styles: _fieldGroupStyles,
    );
  }

  Component _textArea({
    required String labelText,
    required String inputId,
    required String value,
    required String placeholder,
    required void Function(String value) onInput,
  }) {
    return div(
      [
        label(
          [Component.text(labelText)],
          htmlFor: inputId,
          styles: _labelStyles,
        ),
        textarea(
          [Component.text(value)],
          id: inputId,
          rows: 2,
          placeholder: placeholder,
          onInput: onInput,
          styles: _textAreaStyles,
        ),
      ],
      styles: _fieldGroupStyles,
    );
  }

  Component _outputText(String text) {
    return p(
      [Component.text(text)],
      styles: _outputStyles,
    );
  }
}

const _pageShellStyles = Styles(
  raw: {
    'background': '#f4f7fb',
    'min-height': '100vh',
    'padding': '32px 16px',
    'font-family':
        '-apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif',
    'color': '#172033',
  },
);

const _pageSectionStyles = Styles(
  raw: {
    'max-width': '880px',
    'margin': '0 auto',
  },
);

const _stackStyles = Styles(
  raw: {
    'display': 'grid',
    'gap': '16px',
    'margin-top': '24px',
  },
);

const _cardStyles = Styles(
  raw: {
    'background': '#ffffff',
    'border': '1px solid #d8e0ef',
    'border-radius': '16px',
    'padding': '20px',
    'box-shadow': '0 10px 30px rgba(33, 56, 110, 0.06)',
  },
);

const _cardTitleStyles = Styles(
  raw: {
    'margin': '0 0 8px 0',
    'font-size': '1.15rem',
    'font-weight': '700',
  },
);

const _descriptionStyles = Styles(
  raw: {
    'margin': '0',
    'color': '#51607a',
    'line-height': '1.6',
  },
);

const _cardBodyStyles = Styles(
  raw: {
    'display': 'grid',
    'gap': '14px',
    'margin-top': '16px',
  },
);

const _fieldGroupStyles = Styles(
  raw: {
    'display': 'grid',
    'gap': '8px',
  },
);

const _labelStyles = Styles(
  raw: {
    'font-size': '0.95rem',
    'font-weight': '600',
  },
);

const _inputStyles = Styles(
  raw: {
    'width': '100%',
    'box-sizing': 'border-box',
    'padding': '12px 14px',
    'border': '1px solid #b9c6dd',
    'border-radius': '12px',
    'font-size': '1rem',
    'background': '#ffffff',
  },
);

const _textAreaStyles = Styles(
  raw: {
    'width': '100%',
    'box-sizing': 'border-box',
    'padding': '12px 14px',
    'border': '1px solid #b9c6dd',
    'border-radius': '12px',
    'font-size': '1rem',
    'line-height': '1.5',
    'resize': 'vertical',
    'background': '#ffffff',
  },
);

const _buttonRowStyles = Styles(
  raw: {
    'display': 'flex',
    'flex-wrap': 'wrap',
    'gap': '12px',
  },
);

const _filledButtonStyles = Styles(
  raw: {
    'padding': '10px 14px',
    'border': 'none',
    'border-radius': '999px',
    'background': '#1d4ed8',
    'color': '#ffffff',
    'cursor': 'pointer',
    'font-weight': '600',
  },
);

const _outlinedButtonStyles = Styles(
  raw: {
    'padding': '10px 14px',
    'border': '1px solid #1d4ed8',
    'border-radius': '999px',
    'background': '#ffffff',
    'color': '#1d4ed8',
    'cursor': 'pointer',
    'font-weight': '600',
  },
);

const _textButtonStyles = Styles(
  raw: {
    'padding': '10px 14px',
    'border': 'none',
    'border-radius': '999px',
    'background': 'transparent',
    'color': '#475569',
    'cursor': 'pointer',
    'font-weight': '600',
  },
);

const _outputStyles = Styles(
  raw: {
    'margin': '0',
    'font-weight': '600',
    'color': '#22314f',
    'line-height': '1.5',
  },
);
