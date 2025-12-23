# Prompting

## Best Practices

### 1. Task

Describe the task you want the tool to help you with. The task is the foundation of any prompt. It should be clear and specific. If you're vague with your instructions, you're likely to get bad results.

To futher avoid misunderstanding from the tool, include a **persona** and an **output format** in your prompt.
* **Providing a persona**. Specifying a persona instructs an AI tool to draw its expertise form a particular field - filtering out irrelevant information. You can ask the tool to take on perspective of a science expert or an industry analyst, or ask it to create an output geared towards a specific audience, like your manager or team.
* **Providing an output format**. The format is what you wnat the output to look like. Want a bullet list? Or maybe a table so you can compare results side-by-side? Include these details in your prompt.

#### Example

```markdown
You’re a movie critic that specializes in Italian film. Create a table that contains the greatest Italian films of the 1970s, and separate them into genres like thrillers, dramas, and comedies. Provide a 100-word summary of each movie as well as details about the production including director and release year.
```

### 2. Context

The more relevant details you include, the better your output will be. Providing background information—like your goals, the reason for the task, or what you’ve tried before—rounds out the model's understanding of what you're looking for. These details are called context, and they’re a vital part of creating great prompts.

**Context has the potential to be the longest piece of a prompt. One of the most powerful and reliable ways to provide an AI tool with context is to give the model specific reference materials to use.**

#### Bad example:
```markdown
How was DNA discovered?
```

#### Good example:
```markdown
You’re a science expert developing a new curriculum at a local college. Tell me in a couple of engaging paragraphs how DNA was discovered and what kind of impact it had on the world. Write it in a way that people unfamiliar with science would understand. You have gotten feedback from students that they found this course dry and unintelligible before, so you want to make sure that the explanation grabs the students' attention and makes a good first impression.
```

### 3. Reference materials

References are examples or any additional resources that guide an AI tool towards the output you want.

Depending on the gen AI tool you’re using, you can include text, images, and even audio references to sharpen your input. But simply pasting in a reference isn't enough. The key is to clearly label and structure your references so the tool knows exactly what they are and how to use them.

Whether you share your own work or include external references, these techniques can help the AI tool understand exactly what to do with them. And no need to build an exhaustive set of references—two to five should be enough.

#### Use transitional phrases

A simple method is to clearly signal an upcoming reference. For example, using transitional phrases like "Refer to these materials," or "Use the following examples" tells the tool exactly where your reference material begins.

#### Use headings

Labeling your references with headings is another way to clarify where your examples are within a prompt. This can be helpful if you're including multiple examples, or different types of reference materials. For example:

```markdown
Write a one-paragraph product description for a high-end watch with features like a scratch-resistant case and a water resistance rating of up to 30 meters. Base the description style on these examples from our website:

* Sunglasses: Our latest collection of handcrafted, heritage-inspired sunglasses features details like UV-protective lenses in shades specifically chosen to complement each frame—all at a price that won't break the bank. Plus, we made these sunglasses with vintage-inspired acetate frames and a keyhole bridge.

* Cardholder: Crafted in smooth Italian leather, this double-sided cardholder is designed to carry your cash and credit cards without the bulk of a full wallet. Fun fact: this cardholder is made in Naples, Italy, and will look great when you treat your friends to a round of summer spritzes.
```

#### Use XML-style tags

For more complex prompts with multiple references, you can wrap your references in XML tags. These act as labels that mark the beginning and end of each distinct piece of information. For example:

```markdown
<example01>

[Your first example text here]

</example01>
```

#### Markdown tags

These are symbols you can use in prompts to add formatting. For example, if you were to use a gen AI tool to copy-edit your work, you could surround text with `_` to italicize it or `**` to bold it. This preserves your formatting as you move it into a gen AI tool, which generally uses plain, or unformatted text.

### 4. Evaluate your output

Different AI models are trained on unique data and rely on different programming techniques. Some models may be better suited to specific uses like writing code or brainstorming ideas, while others might have limited outputs because of their training sets. No matter the model, running the same prompt multiple times will likely render different results because of how gen AI tools process data.

That’s why it’s so important to evaluate your output. Before you use any AI-generated information, text, or materials, critically evaluate that the output is accurate, unbiased, relevant, and consistent before incorporating it into your workflows. If the output isn’t what you’re looking for, you should iterate on your prompt.

### 5. Iterate on your prompt

**A**lways **B**e **I**terating.
