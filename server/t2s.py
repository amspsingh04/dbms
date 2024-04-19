from transformers import AutoTokenizer, AutoModelForSeq2SeqLM
tokenizer = AutoTokenizer.from_pretrained("dbernsohn/t5_wikisql_en2SQL")
model = AutoModelForSeq2SeqLM.from_pretrained("dbernsohn/t5_wikisql_en2SQL")

query = "how many students have not returned the books they have borrowed?"
input_text = f"translate English to Sql: {query} </s>"
features = tokenizer([input_text], return_tensors='pt')

output = model.generate(input_ids=features['input_ids'].cpu(), 
                        attention_mask=features['attention_mask'].cpu())

print(tokenizer.decode(output[0]))

