import 'package:flutter/material.dart';
import 'package:meu_flash/services/gpt_services/gpt_service.dart';
import 'package:meu_flash/views/chat/message_bubble.dart';

class ChatBalloon extends StatefulWidget {
  ChatBalloon({Key? key}) : super(key: key);

  @override
  _ChatBalloonState createState() => _ChatBalloonState();
}

class _ChatBalloonState extends State<ChatBalloon> {
  final List<MessageBubble> messageBubbles = [];
  final TextEditingController textEditingController = TextEditingController();
  final gptService = GptService();
  bool isChatVisible = true;

  @override
  void initState() {
    super.initState();
    adicionarMensagemDeBoasVindas();
  }

  void adicionarMensagemDeBoasVindas() {
    final mensagemBoasVindas =
        "Olá! Eu sou o Syn, seu assistente de aprendizagem médica. Sinta-se à vontade para me fazer qualquer pergunta relacionada à área médica.";
    setState(() {
      messageBubbles.add(MessageBubble(
        sender: ' ',
        text: mensagemBoasVindas,
        imageUrl: 'lib/assets/bot.jpg',
        isMe: false,
      ));
    });
  }

  void toggleChatVisibility() {
    setState(() {
      isChatVisible = !isChatVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: screenSize.height * 0.8,
        width: screenSize.width * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: toggleChatVisibility,
                ),
              ],
            ),
            isChatVisible ? Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  reverse: true,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: messageBubbles.length,
                    itemBuilder: (context, index) {
                      return messageBubbles[index];
                    },
                  ),
                ),
              ),
            ) : Container(),
            Container(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: SizedBox(
                      height: 56,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        padding: EdgeInsets.only(left: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: TextField(
                          controller: textEditingController,
                          decoration: InputDecoration(
                            hintText: 'Digite sua mensagem aqui...',
                            hintStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          style: TextStyle(color: Colors.black),
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 56,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            final userMessage = textEditingController.text;
                            setState(() {
                              messageBubbles.add(MessageBubble(
                                sender: ' ',
                                text: userMessage,
                                imageUrl: 'lib/assets/user_profile.png',
                                isMe: true,
                              ));
                            });
                            textEditingController.clear();

                            final messages = [
                              {'role': 'system', 'content': 'Você é um assistente útil.'},
                              {'role': 'user', 'content': userMessage},
                            ];

                            try {
                              final botResponse = await gptService.generateResponse(messages);

                              setState(() {
                                messageBubbles.add(MessageBubble(
                                  sender: ' ',
                                  text: botResponse,
                                  imageUrl: 'lib/assets/bot.jpg',
                                  isMe: false,
                                ));
                              });
                            } catch (e) {
                              print('Erro: $e');
                            }
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                            child: Icon(Icons.send, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
